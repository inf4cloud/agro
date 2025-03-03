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
    <link href="../../CSS/estilo.css" rel="stylesheet">

    <script>
        $(document).ready(function() {
        	
        	//Verificando mensagem
    		var mensagem = '<%= request.getAttribute("Mensagem") != null ? request.getAttribute("Mensagem") : "" %>';
   			 var atributo = '<%= request.getAttribute("Atributo") != null ? request.getAttribute("Atributo") : "" %>';

    				if (mensagem && atributo) {
      					 // Chama a função mostrarAlerta
       					 mostrarAlerta(mensagem, atributo);
   			 }
        	
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
                	"url": 'https://cdn.datatables.net/plug-ins/2.1.6/i18n/pt-BR.json' // Tradução para o Português
                }
            });

            // Máscara para campo de valor (moeda BRL)
            $('#valor, #atualizacaoValor').on('input', function() {
                let value = $(this).val();
                $(this).val(formatarMoeda(value));
            });

            $('#formCadastro').on('submit', function(event) {
                event.preventDefault();
                
                let despesa = $('#despesascustos').val().trim();
                let unidade = $('#unidade').val().trim();
                let valor = $('#valor').val().trim();
                let tipo = $('#tipo').val().trim();
                
                // Validações
                if (despesa.length === 0 || unidade.length === 0 || valor.length === 0 || tipo.length === 0) {
                	ExibirAlerta('Erro', 'Todos os campos são obrigatórios.');
                    return;
                }

                if (despesa.length > 50 || unidade.length > 2 || tipo.length > 20) {
                	ExibirAlerta('Erro', 'Um ou mais campos excedem o tamanho máximo permitido.');
                    return;
                }

                if (!/^\d{1,3}(\.\d{3})*,\d{2}$/.test(valor)) {
                	ExibirAlerta('Erro', 'O valor deve estar no formato de decimal (1.234,56).');
                    return;
                }
                
                salvarDespesa(despesa, unidade, valor, tipo);
            });
            function ExibirAlerta(titulo, mensagem) {
                alert(titulo + ": " + mensagem);
            }
            $('#formAtualizacao').on('submit', function(event) {
                event.preventDefault();

                let id = $('#atualizacaoId').val();
                let despesa = $('#atualizacaoDespesa').val().trim();
                let unidade = $('#atualizacaoUnidade').val().trim();
                let valor = $('#atualizacaoValor').val().trim();
                let tipo = $('#atualizacaoTipo').val().trim();

                // Validações
                if (despesa.length === 0 || unidade.length === 0 || valor.length === 0 || tipo.length === 0) {
                	ExibirAlerta('Erro', 'Todos os campos são obrigatórios.');
                    return;
                }

                if (despesa.length > 50 || unidade.length > 2 || tipo.length > 20) {
                	ExibirAlerta('Erro', 'Um ou mais campos excedem o tamanho máximo permitido.');
                    return;
                }

                if (!/^\d{1,3}(\.\d{3})*,\d{2}$/.test(valor)) {
                	ExibirAlerta('Erro', 'O valor deve estar no formato de moeda brasileira (1.234,56).');
                    return;
                }

                atualizarDespesa(id, despesa, unidade, valor, tipo);
            });
        });
        //Mostrar mensagem
			function mostrarAlerta(mensagem, tipo) {
						 const alerta = $('#alerta');

								  // Remove todas as classes de alerta anteriores
								  alerta.removeClass('d-none alert-success alert-danger alert-info alert-warning');

								  // Adiciona a classe apropriada ao alerta
									  alerta.addClass('alert alert-' + tipo);

									 // Define a mensagem do alerta
										 alerta.text(mensagem);

										  // Exibe o alerta
											  alerta.fadeIn();

										// Oculta o alerta após 5 segundos
											 setTimeout(() => {
												 alerta.fadeOut(() => {
											     alerta.addClass('d-none'); // Reaplica 'd-none' para esconder
											 });
									}, 5000);
							}

        // Função para formatar o valor em moeda BRL
        function formatarMoeda(valor) {
            valor = valor.replace(/\D/g, "")
                         .replace(/(\d{1,2})$/, ',$1')
                         .replace(/(?=(\d{3})+(\D))\B/g, ".");
            return valor;
        }

        function abrirModalAtualizacao(id, despesa, unidade, valor, tipo) {
            $('#atualizacaoId').val(id);
            $('#atualizacaoDespesa').val(despesa);
            $('#atualizacaoUnidade').val(unidade);
            $('#atualizacaoValor').val(valor);
            $('#atualizacaoTipo').val(tipo);
            $('#modalAtualizacao').modal('show');
        }

        function abrirModalExclusao(id, despesa) {
            $('#exclusaoId').val(id);
            $('#exclusaoDespesa').text(despesa);
            $('#modalExclusao').modal('show');
        }

       

        function salvarDespesa(despesa, unidade, valor, tipo) {
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
                	 mostrarAlerta('Despesa cadastrada com sucesso!','success');
                    $('#modalCadastro').modal('hide');
                    $('#formCadastro')[0].reset();
                    $('#tabelaDespesasCustos').DataTable().ajax.reload();
                },
                error: function(xhr) {
                    console.log( xhr.responseText);
                    mostrarAlerta('Despesa não cadastrada!','danger');
                }
            });
        }

        function atualizarDespesa(id, despesa, unidade, valor, tipo) {
            $.ajax({
                url: '/agro/DespesasCustosServlet',
                method: 'POST',
                data: {
                    acao: 'update',
                    iddespesascustos: id,
                    despesascustos: despesa,
                    unidadedespesacustos: unidade,
                    valordespesacustos: valor,
                    tipodespesacustos: tipo
                },
                success: function(response) {
                	 mostrarAlerta('Despesa atualizada:   com sucesso','info');
                    $('#modalAtualizacao').modal('hide');
                    $('#formAtualizacao')[0].reset();
                    $('#tabelaDespesasCustos').DataTable().ajax.reload();
                },
                error: function(xhr) {
                    console.log('Atenção: ' + xhr.responseText);
                    mostrarAlerta('Despesa não atualizada!','danger');
                }
            });
        }

        function excluirDespesa() {
            var id = $('#exclusaoId').val();

            $.ajax({
                url: '/agro/DespesasCustosServlet',
                method: 'POST',
                data: {
                    acao: 'delete',
                    iddespesascusto: id
                },
                success: function(response) {
                	 mostrarAlerta('Despesa excluída com sucesso!','info');
                    $('#modalExclusao').modal('hide');
                    $('#tabelaDespesasCustos').DataTable().ajax.reload();
                },
                error: function(xhr) {
                    alert('Atenção: ' + xhr.responseText);
                    mostrarAlerta('Despesa não excluída com sucesso!','danger');
                }
            });
        }
    </script>
</head>
<body>
    <header>
        <%@ include file="../../pagina/menu.jsp"%>
    </header>

    <div class="container-fluid content mt-2">
        <h2 class="mb-2 text-white border bg-success p-2 rounded shadow-custom">Despesas/Custos</h2>
			 <div id="alerta" class="alert d-none " role="alert"></div>
      <button id="btnCadastro" type="button" class="btn btn-primary mt-4 mb-3" data-toggle="modal" data-target="#modalCadastro">
        <i class="fas fa-plus"></i> <span class="texto-botao">Cadastrar Despesa/Custo</span>
    </button>

        <div class="table-responsive rounded shadow-custom m-2 p-2">
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
                </tbody>
            </table>
        </div>
    </div>

   <!-- Modal de Cadastro -->
<div id="modalCadastro" class="modal fade" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title"><i class="fas fa-plus-circle mr-2"></i>Cadastrar Despesa/Custo</h5>
                <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form id="formCadastro">
                    <div class="form-group">
                        <label for="despesascustos">Despesa/Custo:</label>
                        <input type="text" id="despesascustos" name="despesascustos" class="form-control" required maxlength="50" placeholder="Ex.: Aluguel">
                    </div>
                    <div class="form-group">
                        <label for="unidade">Unidade:</label>
                        <input type="text" id="unidade" name="unidade" class="form-control" required maxlength="2" placeholder="Ex.: un">
                    </div>
                    <div class="form-group">
                        <label for="valor">Valor:</label>
                        <input type="text" id="valor" name="valor" class="form-control" required pattern="\d{1,3}(\.\d{3})*,\d{2}" placeholder="0,00">
                    </div>
                    <div class="form-group">
                        <label for="tipo">Tipo:</label>
                        <input type="text" id="tipo" name="tipo" class="form-control" required maxlength="20" placeholder="Ex.: Fixo">
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-primary">Salvar</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Modal de Atualização -->
<div id="modalAtualizacao" class="modal fade" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header bg-info text-white">
                <h5 class="modal-title"><i class="fas fa-edit mr-2"></i>Atualizar Despesa/Custo</h5>
                <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form id="formAtualizacao">
                    <input type="hidden" id="atualizacaoId" name="id">
                    <div class="form-group">
                        <label for="atualizacaoDespesa">Despesa/Custo:</label>
                        <input type="text" id="atualizacaoDespesa" name="despesascusto" class="form-control" required maxlength="50">
                    </div>
                    <div class="form-group">
                        <label for="atualizacaoUnidade">Unidade:</label>
                        <input type="text" id="atualizacaoUnidade" name="unidadedespesacusto" class="form-control" required maxlength="2">
                    </div>
                    <div class="form-group">
                        <label for="atualizacaoValor">Valor:</label>
                        <input type="text" id="atualizacaoValor" name="valordespesacusto" class="form-control" required pattern="\d{1,3}(\.\d{3})*,\d{2}" placeholder="0,00">
                    </div>
                    <div class="form-group">
                        <label for="atualizacaoTipo">Tipo:</label>
                        <input type="text" id="atualizacaoTipo" name="tipodespesacusto" class="form-control" required maxlength="20">
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-info">Atualizar</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Modal de Exclusão -->
<div id="modalExclusao" class="modal fade" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title"><i class="fas fa-trash-alt mr-2"></i>Excluir Despesa/Custo</h5>
                <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
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
        <%@ include file="../../pagina/footer.jsp"%>
    </footer>
</body>
</html>
