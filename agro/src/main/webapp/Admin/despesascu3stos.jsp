<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html>
<head>
    <title>Info4Cloud - Despesas/Custos</title>
    <!-- Incluindo o CSS do Bootstrap 4 -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- JavaScript do Bootstrap 4 -->
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.bundle.min.js"></script>
    <!-- DataTables CSS e JS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.11.5/css/jquery.dataTables.min.css">
    <script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <!-- CSS customizado -->
    <link href="../CSS/estilo.css" rel="stylesheet">

    <script>
        $(document).ready(function() {
            // Inicializa o DataTable
            const tabela = $('#tabelaDespesasCustos').DataTable({
                "processing": true,
                "serverSide": false,
                "ajax": {
                    "url": "/agro/DespesasCustosServlet", // URL da servlet para buscar os dados
                    "method": "GET",
                    "dataSrc": "" // Define que os dados virão no formato de array
                },
                "columns": [
                    { "data": "iddespesascusto" },
                    { "data": "despesascusto" },
                    { "data": "unidadedespesascustos" },
                    { "data": "valordespesascustos" },
                    { "data": "tipodespesascustos" },
                    {
                        "data": null,
                        "render": function(data, type, row) {
                            // Cria botões de ação para cada linha
                            return '<button class="btn btn-sm btn-warning btn-responsivo" onclick="abrirModalAtualizacao('
                            		+ row.iddespesascusto +', \'' 
                            		+ row.despesascusto +'\', \'' 
                            		+ row.unidadedespesascustos +'\', \'' 
                            		+ row.valordespesascustos +'\', \''
                            		+ row.tipodespesascustos + '\')"><i class="fas fa-sync"></i><span class="texto-botao">Atualizar</span></button> ' +
                                   '<button class="btn btn-sm btn-danger btn-responsivo" onclick="abrirModalExclusao(' + row.iddespesascusto + ', \'' + row.despesascusto + '\')"><i class="fas fa-trash-alt"></i><span class="texto-botao">Excluir</span></button>';
                        }
                    }
                ],
                "language": {
                    "url": "//cdn.datatables.net/plug-ins/2.1.6/i18n/pt-BR.json" // Tradução para o Português
                }
            });
        });
        $('#formCadastro').on('submit', function(event) {
            event.preventDefault();
            
            let despesa = $('#despesascustos').val();
            let unidade = $('#unidade').val();
            let valor = $('#valor').val();
            let tipo = $('#tipo').val();
            
            // Validações
            if (despesa.length > 50 || unidade.length > 2 || tipo.length > 20) {
                mostrarAlerta('Erro', 'Um ou mais campos excedem o tamanho máximo permitido.');
                return;
            }
            
            if (!despesa || !unidade || !valor || !tipo) {
                mostrarAlerta('Erro', 'Todos os campos são obrigatórios.');
                return;
            }
            
            salvarDespesa(despesa, unidade, valor, tipo);
        });

        // Máscara para campo de valor (moeda BRL)
        $('#valor').on('input', function() {
            let value = $(this).val();
            $(this).val(formatarMoeda(value));
        });

        // Função para formatar o valor em moeda BRL
        function formatarMoeda(valor) {
            return valor.replace(/\D/g, "")
                        .replace(/(\d)(\d{2})$/, "$1,$2")
                        .replace(/(?=(\d{3})+(\D))\B/g, ".");
        }

        function abrirModalAtualizacao(id, despesa, unidade, valor,tipo) {
            // Define os valores no modal de atualização
            $('#atualizacaoId').val(id);
            $('#atualizacaoDespesa').val(despesa);
            $('#atualizacaoUnidade').val(unidade);
            $('#atualizacaoValor').val(valor);
            $('#atualizacaoTipo').val(tipo);
            $('#modalAtualizacao').modal('show');
        }

        function abrirModalExclusao(id, despesa) {
            // Define os valores no modal de exclusão
            $('#exclusaoId').val(id);
            $('#exclusaoDespesa').text(despesa);
            $('#modalExclusao').modal('show');
        }

        function salvarDespesa() {
            // Captura os valores dos campos de entrada do formulário de cadastro
            var despesa = $('#despesascustos').val();
            var unidade = $('#unidade').val();
            var valor = $('#valor').val();
            var tipo = $('#tipo').val();

            // Envia os dados para a servlet usando AJAX
            $.ajax({
                url: '/agro/DespesasCustosServlet',
                method: 'POST',
                data: {
                    acao: 'create',
                    despesascusto: despesa,
                    unidadedespesacusto: unidade,
                    valordespesacusto: valor,
                    tipodespesacusto: tipo
                },
                success: function(response) {
                    alert('Despesa cadastrada com sucesso!');
                    $('#modalCadastro').modal('hide'); // Fecha o modal de cadastro
                    $('#formCadastro')[0].reset(); // Reseta o formulário de cadastro
                    $('#tabelaDespesasCustos').DataTable().ajax.reload(); // Recarrega o DataTable
                },
                error: function(xhr) {
                    alert('Atenção : ' + xhr.responseText);
                }
            });
        }

        function atualizarDespesa() {
            // Captura os valores dos campos de entrada do formulário de atualização
            var id = $('#atualizacaoId').val();
            var despesa = $('#atualizacaoDespesa').val();
            var unidade = $('#atualizacaoUnidade').val();
            var valor = $('#atualizacaoValor').val();
            var tipo = $('#atualizacaoTipo').val();

            // Envia os dados atualizados para a servlet usando AJAX
            $.ajax({
                url: '/agro/DespesasCustosServlet',
                method: 'POST',
                data: {
                    acao: 'update',
                    iddespesascustos: id,
                    despesascustos: despesa,
                    unidadedespesacustos: unidade,
                    valordespesacustos: valor,
                    tipodespesacustos: tipo,
                },
                success: function(response) {
                    alert('Despesa atualizada com sucesso!');
                    $('#modalAtualizacao').modal('hide'); // Fecha o modal de atualização
                    $('#formAtualizacao')[0].reset(); // Reseta o formulário de atualização
                    $('#tabelaDespesasCustos').DataTable().ajax.reload(); // Recarrega o DataTable
                },
                error: function(xhr) {
                    alert('Atenção: ' + xhr.responseText);
                }
            });
        }

        function excluirDespesa() {
            // Captura o ID da despesa que será excluída
            var id = $('#exclusaoId').val();

            // Envia o ID para a servlet para realizar a exclusão
            $.ajax({
                url: '/agro/DespesasCustosServlet',
                method: 'POST',
                data: {
                    
                    iddespesascusto: id
                },
                success: function(response) {
                    alert('Despesa excluída com sucesso!');
                    $('#modalExclusao').modal('hide'); // Fecha o modal de exclusão
                    $('#tabelaDespesasCustos').DataTable().ajax.reload(); // Recarrega o DataTable
                },
                error: function(xhr) {
                    alert('Atenção:: ' + xhr.responseText);
                }
            });
        }
    </script>
</head>
<body>
    <header>
        <%@ include file="../pagina/menu.jsp"%>
    </header>

    <div class="container-fluid content mt-2">
        <h2 class="mb-2 text-white border bg-success p-2 rounded shadow-custom">Despesas/Custos</h2>

       
        <!-- Botão para abrir o modal de cadastro -->
        <button id="btnCadastro" type="button" class="btn btn-primary mt-4 mb-3" data-toggle="modal" data-target="#modalCadastro">
            <i class="fas fa-plus"></i> <span class="texto-botao">Cadastrar Despesa/Custo</span>
        </button>

        <!-- Tabela para exibição das despesas/custos -->
        <div class="table-responsive rounded shadow-custom">
            <table id="tabelaDespesasCustos" class="table table-bordered table-striped">
                <thead class="thead-green">
                    <tr>
                        <th>ID</th>
                        <th>Despesa/Custo</th>
                        <th>Unidade</th>
                        <th>Valor</th>
                        <th>Tipo</th>
                        <th>Ações</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- Dados serão carregados dinamicamente pelo DataTables -->
                </tbody>
            </table>
        </div>
    </div>

    <!-- Modal de cadastro -->
    <div id="modalCadastro" class="modal fade" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Cadastrar Despesa/Custo</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form id="formCadastro">
                        <div class="form-group">
                            <label for="despesascustos">Despesa/Custo:</label>
                            <input type="text" id="despesascustos" name="despesascustos" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label for="unidade">Unidade:</label>
                            <input type="text" id="unidade" name="unidade" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label for="valor">Valor:</label>
                            <input type="number" id="valor" name="valor" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label for="tipo">Tipo:</label>
                            <input type="text" id="tipo" name="tipo" class="form-control" required>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                            <button type="button" class="btn btn-primary" onclick="salvarDespesa()">Salvar</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal de atualização -->
    <div id="modalAtualizacao" class="modal fade" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Atualizar Despesa/Custo</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form id="formAtualizacao">
                        <input type="hidden" id="atualizacaoId" name="id">
                        <div class="form-group">
                            <label for="atualizacaoDespesa">Despesa/Custo:</label>
                            <input type="text" id="atualizacaoDespesa" name="despesascusto" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label for="atualizacaoUnidade">Unidade:</label>
                            <input type="text" id="atualizacaoUnidade" name="unidadedespesacusto" class="form-control" required>
                        </div>
                         <div class="form-group">
                            <label for="atualizacaoValor">Valor</label>
                            <input type="text" id="atualizacaoValor" name="valordespesacusto" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label for="atualizacaoTipo">Tipo:</label>
                            <input type="text" id="atualizacaoTipo" name="tipodespesacusto" class="form-control" required>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                            <button type="button" class="btn btn-primary" onclick="atualizarDespesa()">Atualizar</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal de exclusão -->
    <div id="modalExclusao" class="modal fade" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Excluir Despesa/Custo</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p>Tem certeza de que deseja excluir a despesa/custo <strong id="exclusaoDespesa"></strong>?</p>
                    <input type="hidden" id="exclusaoId" name="id">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                    <button type="button" class="btn btn-danger" onclick="excluirDespesa()">Excluir</button>
                </div>
            </div>
        </div>
    </div>
    <footer>
	<%@ include file="../pagina/footer.jsp"%>
</footer>
</body>
</html>
