<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html>
    <head>
        <title>Info4Cloud</title>
        
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
            $(document).ready(function () {
                // Verificando mensagem
                var mensagem = '<%= request.getAttribute("Mensagem") != null ? request.getAttribute("Mensagem") : ""%>';
                var atributo = '<%= request.getAttribute("Atributo") != null ? request.getAttribute("Atributo") : ""%>';

                if (mensagem && atributo) {
                    mostrarAlerta(mensagem, atributo);
                }
                // Chama a função para carregar a classificação após 3 segundos
              
                 setInterval(function () {
            CarregarClassificacao();
        }, 3000);
            });
            function CarregarClassificacao() {

                // Inicializa o DataTable
                const tabela = $('#tabelaClassificacao').DataTable({
                    "processing": false,
                    "serverSide": false,
                  
                    "ajax": {
                        "url": "/agro/ClassificacaoServlet",
                        "method": "GET",
                        "dataSrc": ""
                    },
                    "columns": [
                        {"data": "idclassificacao"},
                        {"data": "classificacao"},
                        {
                            "data": null,
                            "title": "Ações",

                            "render": function (data, type, row) {
                                return '<button class="btn btn-sm btn-warning btn-responsivo" onclick="abrirModalAtualizacao('
                                        + row.idclassificacao + ', \''

                                        + row.classificacao + '\')"><i class="fas fa-sync"></i><span class="texto-botao">Atualizar</span></button> ' +
                                        '<button class="btn btn-sm btn-danger btn-responsivo" onclick="abrirModalExclusao(' + row.idclassificacao + ', \'' + row.classificacao + '\')"><i class="fas fa-trash-alt"></i><span class="texto-botao">Excluir</span></button>';
                            }
                        }
                    ],
                    "language": {
                        "url": 'https://cdn.datatables.net/plug-ins/2.1.6/i18n/pt-BR.json'
                    }
                });
            }

            function abrirModalAtualizacao(id, classificacao) {
                $('#atualizacaoId').val(id);
                $('#atualizacaoClassificacao').val(classificacao);
                $('#modalAtualizacao').modal('show');
            }

            function abrirModalExclusao(id, classificacao) {
                $('#exclusaoId').val(id);
                $('#exclusaoClassificacao').val(classificacao);
                $('#modalExclusao').modal('show');
            }

            function salvarClassificacao() {
                const classificacao = $('#classificacao').val();
                if (classificacao.trim() === '') {
                    alert('Por favor, preencha a classificação.');
                    return;
                }
                $.ajax({
                    url: '/agro/ClassificacaoServlet',
                    method: 'POST',
                    data: {classificacao: classificacao},
                    success: function (response) {
                        mostrarAlerta(response.message, 'success');
                        $('#modalCadastro').modal('hide');
                        $('#classificacao').val("");
                        $('#tabelaClassificacao').DataTable().ajax.reload();
                    },
                    error: function (xhr) {
                        mostrarAlerta("Erro em cadastrar", 'danger');
                        alert('Erro ao cadastrar classificação: ' + xhr.responseJSON.error);
                    }
                });
            }

            function atualizarClassificacao() {
                const id = $('#atualizacaoId').val();
                const classificacao = $('#atualizacaoClassificacao').val();
                if (classificacao.trim() === '') {
                    alert('Por favor, preencha a classificação.');
                    return;
                }
                $.ajax({
                    url: '/agro/ClassificacaoServlet',
                    method: 'POST',
                    data: {id: id, classificacao: classificacao},
                    success: function (response) {
                        mostrarAlerta(response.message, 'success');

                        $('#modalAtualizacao').modal('hide');
                        $('#tabelaClassificacao').DataTable().ajax.reload();
                    },
                    error: function (xhr) {
                        mostrarAlerta('Erro em atualizar a Classificação', 'danger');
                        console.log('Erro ao atualizar classificação: ' + (xhr.responseJSON ? xhr.responseJSON.error : 'Erro desconhecido'));
                    }
                });
            }

            function excluirClassificacao() {
                const id = $('#exclusaoId').val();
                $.ajax({
                    url: '/agro/ClassificacaoServlet',
                    method: 'POST',
                    data: {id: id, acao: 'Delete'},
                    success: function (response) {
                        mostrarAlerta(response.message, 'success');
                        $('#modalExclusao').modal('hide');
                        $('#tabelaClassificacao').DataTable().ajax.reload();
                    },
                    error: function (xhr) {
                        mostrarAlerta('Erro em excluir o dado!', 'danger');
                        console.log('Erro ao excluir classificação: ' + (xhr.responseJSON ? xhr.responseJSON.error : 'Erro desconhecido'));
                    }
                });
            }
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

        </script>
    </head>
    <body>
        <header>
            <%@ include file="../../pagina/menu.jsp"%>
        </header>
        <div class="container-fluid content mt-2">
            <h2 class="mb-2 text-white border bg-success p-2 rounded shadow-custom">Classificações</h2>
            <div id="alerta" class="alert d-none " role="alert"></div>
             <button id="btnCadastro" type="button" class="btn btn-primary mt-4" data-toggle="modal" data-target="#modalCadastro">
                <i class="fas fa-plus"></i> Classificação
            </button>
            <div class="table-responsive rounded shadow-custom m-2 p-2">
                
                <table id="tabelaClassificacao" class="table table-bordered table-striped">
                    <thead class="thead-green">
                        <tr>
                            <th>ID</th>
                            <th>Classificação</th>
                            <th>Ações</th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
                 
            </div>
           
        </div>



        <!-- Modal de Cadastro de Classificação -->

        <div class="modal fade" id="modalCadastro" tabindex="-1" role="dialog"
             aria-labelledby="modalCadastroLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalCadastroLabel">Cadastrar Classificação</h5>
                        <button type="button" class="close" data-dismiss="modal"aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <form id="formCadastro">
                            <div class="form-group">
                                <label for="classificacao">Classificação</label> 
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text"><i class=" ml-1 fas fa-list-alt text-info"></i></span>

                                        <input type="text" id="classificacao"  name="classificacao" class="form-control ml-1">
                                    </div>
                                </div>

                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                       <button type="button" class="btn btn-primary" onclick="salvarClassificacao()">Salvar</button>
                       <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal de Atualização de Classificação -->
        <div class="modal fade" id="modalAtualizacao" tabindex="-1" role="dialog" aria-labelledby="modalAtualizacaoLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalAtualizacaoLabel">Atualizar Classificação</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <form id="formAtualizacao">
                            <input type="hidden" id="atualizacaoId"  name="atualizacaoId">
                            <div class="form-group">
                                <label for="atualizacaoClassificacao">Classificação</label> 
                                <input type="text" class="form-control" id="atualizacaoClassificacao" name="atualizacaoClassificacao" required>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" onclick="atualizarClassificacao()">Atualizar</button>
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal de Confirmação de Exclusão -->
        <div class="modal fade" id="modalExclusao" tabindex="-1" role="dialog" aria-labelledby="modalExclusaoLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalExclusaoLabel">Confirmar Exclusão</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <form>
                            <p>Tem certeza de que deseja excluir esta classificação?</p>
                            <input type="hidden" id="exclusaoId" name= "exclusaoId">
                            <input type="hidden" id="deletar" value="Delete">
                            <text>Este dados não vai existir no banco de dados em caso de deletar!!!!</text>
                            <strong id="exclusaoClassificacao"></strong>
                        </form>	
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-danger" onclick="excluirClassificacao()">Excluir</button>
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                    </div>


                </div>
            </div>
        </div>
    </div>
    <footer>
        <%@ include file="../../pagina/footer.jsp"%>
    </footer>
</body>
</html>
