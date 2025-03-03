<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html>
<head>
    <title>Info4Cloud - Parceiros</title>
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
            // Inicializa o DataTable
            const tabela = $('#tabelaParceiros').DataTable({
                "processing": true,
                "serverSide": false,
                "ajax": {
                    "url": "/agro/ControllerParceiro", // URL da servlet para buscar os dados 
                    "method": "GET",
                    "dataSrc": "" // Define que os dados virão no formato de array
                },
                "columns": [
                    { "data": "nomePessoa" },
                    { 
                        "data": "situacaoPessoa", 
                        "render": function(data) {
                            // Badge para situação
                            if (data) {
                                return '<span class="badge badge-success">Ativo</span>';
                            } else {
                                return '<span class="badge badge-danger">Inativo</span>';
                            }
                        }
                    },
                    { "data": "emailPessoa" },
                    { "data": "telefonePessoa" },
                    { "data": "razaoSocialPessoaCnpj" },
                    {
                        "data": null,
                        "render": function(data, type, row) {
                            return '<button class="btn btn-sm btn-warning" onclick="abrirModalAtualizacao('
                                    + row.idPessoa +', \'' 
                                    + row.nomePessoa +'\', \'' 
                                    + row.emailPessoa +'\', \'' 
                                    + row.telefonePessoa +'\', \'' 
                                    + row.razaoSocialPessoaCnpj +'\')"><i class="fas fa-sync"></i> Atualizar</button> ' +
                                   '<button class="btn btn-sm btn-danger" onclick="abrirModalExclusao(' + row.idPessoa + ', \'' + row.nomePessoa + '\')"><i class="fas fa-trash-alt"></i> Excluir</button> ' +
                                   '<button class="btn btn-sm btn-info" onclick="abrirModalDetalhes(' + row.idPessoa + ')"><i class="fas fa-info-circle"></i> Detalhes</button>';
                        }
                    }
                ],
                "language": {
                    "url": "//cdn.datatables.net/plug-ins/2.1.6/i18n/pt-BR.json" // Tradução para o Português
                }
            });

            // Funções para abrir modais
            window.abrirModalAtualizacao = function(id, nome, email, telefone, razaoSocial) {
                $('#atualizacaoId').val(id);
                $('#atualizacaoNome').val(nome);
                $('#atualizacaoEmail').val(email);
                $('#atualizacaoTelefone').val(telefone);
                $('#atualizacaoRazaoSocial').val(razaoSocial);
                $('#modalAtualizacao').modal('show');
            };

            window.abrirModalExclusao = function(id, nome) {
                $('#exclusaoId').val(id);
                $('#exclusaoNome').text(nome);
                $('#modalExclusao').modal('show');
            };

            window.abrirModalDetalhes = function(id) {
                $.ajax({
                    url: '/agro/ControllerParceiro', // URL da servlet para buscar os detalhes
                    method: 'GET',
                    data: { id: id }, // Envia o ID do parceiro para obter detalhes
                    success: function(response) {
                        // Preencher os dados do parceiro no modal
                        $('#detalhesNome').text(response.nomePessoa);
                        $('#detalhesUsuario').text(response.usuarioPessoa);
                        $('#detalhesSenha').text(response.senhaPessoa);
                        $('#detalhesNivel').text(response.nivelPessoa);
                        $('#detalhesEmail').text(response.emailPessoa);
                        $('#detalhesTelefone').text(response.telefonePessoa);
                        $('#detalhesCnpj').text(response.cnpjPessoaCnpj);
                        $('#detalhesRazaoSocial').text(response.razaoSocialPessoaCnpj);
                        $('#detalhesInscricaoEstadual').text(response.inscricaoEstadualPessoaCnpj);
                        $('#detalhesSite').text(response.siteparceiro);
                        $('#detalhesEndereco').text(response.endereco.Endereco + ', ' + response.numero);
                        $('#detalhesCep').text(response.endereco.Cep);
                        $('#detalhesBairro').text(response.endereco.Bairro);
                        $('#detalhesCidade').text(response.endereco.Cidade);
                        $('#detalhesEstado').text(response.endereco.Estado);
                        $('#detalhesPais').text(response.endereco.Pais);

                        // Adiciona a badge de Situação no modal
                        if (response.situacaoPessoa) {
                            $('#detalhesSituacao').html('<span class="badge badge-success">Ativo</span>');
                        } else {
                            $('#detalhesSituacao').html('<span class="badge badge-danger">Inativo</span>');
                        }

                        $('#modalDetalhes').modal('show');
                    },
                    error: function(xhr) {
                        alert('Erro ao buscar detalhes do parceiro.');
                    }
                });
            };



            window.excluirDespesa = function() {
                let id = $('#exclusaoId').val();
                // Adicione a lógica para excluir a despesa/custo
                alert('Parceiro ' + id + ' excluído com sucesso!');
                $('#modalExclusao').modal('hide');
                tabela.ajax.reload(); // Atualiza a tabela após a exclusão
                
            };
        });
    </script>
</head>
<body>
    <header>
        <%@ include file="../../pagina/menu.jsp"%>
    </header>

    <div class="container-fluid content mt-2">
        <h2 class="mb-2 text-white border bg-success p-2 rounded shadow-custom">Parceiros</h2>
        <a class="btn btn-primary mt-4 mb-3" href="/agro/Admin/CadastroParceiro.jsp" role="button">
            <i class="fas fa-plus"></i> Cadastrar Parceiros
        </a>
        <div class="table-responsive rounded shadow-custom">
            <table id="tabelaParceiros" class="table table-bordered table-striped">
                <thead class="thead-green">
                    <tr>
                        <th>Nome</th>
                        <th>Situação</th>
                        <th>Email</th>
                        <th>Telefone</th>
                        <th>Razão Social</th>
                        <th>Ações</th>
                    </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
    </div>

 <!-- Modal de detalhes personalizado -->
<div id="modalDetalhes" class="modal fade" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title"><i class="fas fa-info-circle"></i> Detalhes do Parceiro</h5>
                <button type="button" class="close text-white" data-dismiss="modal" aria-label="Fechar">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <!-- Sessão de Dados da Empresa -->
                <div class="row">
                    <div class="col-12">
                        <h4 class="text-center"><i class="fas fa-building"></i> Dados da Empresa</h4>
                        <hr>
                    </div>
                </div>
                <div class="row mb-3">
                    <div class="col-md-6">
                        <p><strong><i class="fas fa-user"></i> Nome:</strong> <span id="detalhesNome"></span></p>
                    </div>
                    <div class="col-md-6">
                        <p><strong><i class="fas fa-user-shield"></i> Usuário:</strong> <span id="detalhesUsuario"></span></p>
                    </div>
                </div>
                <div class="row mb-3">
                    <div class="col-md-4">
                        <p><strong><i class="fas fa-lock"></i> Nível:</strong> <span id="detalhesNivel"></span></p>
                    </div>
                     <div class="col-md-4">
       						 <p><strong><i class="fas fa-toggle-on"></i> Situação:</strong>
            				<span id="detalhesSituacao"></span>
       					 </p>
    				</div>
                    <div class="col-md-4">
                        <p><strong><i class="fas fa-envelope"></i> Email:</strong> <span id="detalhesEmail"></span></p>
                    </div>
                </div>
                <div class="row mb-3">
                    <div class="col-md-6">
                        <p><strong><i class="fas fa-phone"></i> Telefone:</strong> <span id="detalhesTelefone"></span></p>
                    </div>
                    <div class="col-md-6">
                        <p><strong><i class="fas fa-building"></i> Razão Social:</strong> <span id="detalhesRazaoSocial"></span></p>
                    </div>
                </div>

                <!-- Sessão de Dados do CNPJ -->
                <div class="row">
                    <div class="col-12">
                        <h4 class="text-center"><i class="fas fa-id-card"></i> Dados do CNPJ</h4>
                        <hr>
                    </div>
                </div>
                <div class="row mb-3">
                    <div class="col-md-6">
                        <p><strong><i class="fas fa-id-card-alt"></i> CNPJ:</strong> <span id="detalhesCnpj"></span></p>
                    </div>
                    <div class="col-md-6">
                        <p><strong><i class="fas fa-file-alt"></i> Inscrição Estadual:</strong> <span id="detalhesInscricaoEstadual"></span></p>
                    </div>
                </div>
                <div class="row mb-3">
                    <div class="col-md-12">
                        <p><strong><i class="fas fa-globe"></i> Site:</strong> <span id="detalhesSite"></span></p>
                    </div>
                </div>

                <!-- Sessão de Endereço -->
                <div class="row">
                    <div class="col-12">
                        <h4 class="text-center"><i class="fas fa-map-marker-alt"></i> Endereço do Parceiro</h4>
                        <hr>
                    </div>
                </div>
                <div class="row mb-3">
                    <div class="col-md-6">
                        <p><strong><i class="fas fa-home"></i> Endereço:</strong> <span id="detalhesEndereco"></span></p>
                    </div>
                    <div class="col-md-3">
                        <p><strong><i class="fas fa-map-pin"></i> CEP:</strong> <span id="detalhesCep"></span></p>
                    </div>
                    <div class="col-md-3">
                        <p><strong><i class="fas fa-map"></i> Bairro:</strong> <span id="detalhesBairro"></span></p>
                    </div>
                </div>
                <div class="row mb-3">
                    <div class="col-md-6">
                        <p><strong><i class="fas fa-city"></i> Cidade:</strong> <span id="detalhesCidade"></span></p>
                    </div>
                    <div class="col-md-3">
                        <p><strong><i class="fas fa-flag"></i> Estado:</strong> <span id="detalhesEstado"></span></p>
                    </div>
                    <div class="col-md-3">
                        <p><strong><i class="fas fa-globe-americas"></i> País:</strong> <span id="detalhesPais"></span></p>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal"><i class="fas fa-times"></i> Fechar</button>
            </div>
        </div>
    </div>
</div>


    <!-- Modal de atualização -->
    <div id="modalAtualizacao" class="modal fade" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Atualizar Parceiro</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form id="formAtualizacao">
                        <input type="hidden" id="atualizacaoId" name="id">
                        <div class="form-group">
                            <label for="atualizacaoNome">Nome:</label>
                            <input type="text" id="atualizacaoNome" name="nomePessoa" class="form-control" required maxlength="50">
                        </div>
                        <div class="form-group">
                            <label for="atualizacaoEmail">Email:</label>
                            <input type="email" id="atualizacaoEmail" name="emailPessoa" class="form-control" required maxlength="100">
                        </div>
                        <div class="form-group">
                            <label for="atualizacaoTelefone">Telefone:</label>
                            <input type="text" id="atualizacaoTelefone" name="telefonePessoa" class="form-control" required maxlength="15">
                        </div>
                        <div class="form-group">
                            <label for="atualizacaoRazaoSocial">Razão Social:</label>
                            <input type="text" id="atualizacaoRazaoSocial" name="razaoSocialPessoaCnpj" class="form-control" required maxlength="100">
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                            <button type="submit" class="btn btn-primary">Atualizar</button>
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
                    <h5 class="modal-title">Excluir Parceiro</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p>Tem certeza de que deseja excluir o parceiro <strong id="exclusaoNome"></strong>?</p>
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