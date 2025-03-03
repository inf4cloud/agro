<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html lang="pt-br">
<head>
<meta charset="UTF-8">
<title>AgroFazenda</title>
<!-- Bootstrap 4 CSS -->
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<!-- Font Awesome -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<!-- CSS customizado -->
<link href="../../CSS/estilo.css" rel="stylesheet">
<script>
function limpa_formulário_cep() {
    //Limpa valores do formulário de cep.
    document.getElementById('endereco').value=("");
    document.getElementById('bairro').value=("");
    document.getElementById('cidade').value=("");
    document.getElementById('estado').value=("");
  
}
function meu_callback(conteudo) {
    if (!("erro" in conteudo)) {
        //Atualiza os campos com os valores.
        document.getElementById('endereco').value=(conteudo.logradouro);
        document.getElementById('bairro').value=(conteudo.bairro);
        document.getElementById('cidade').value=(conteudo.localidade);
        document.getElementById('estado').value=(conteudo.estado);
    } //end if.
    else {
        //CEP não Encontrado.
        limpa_formulário_cep();
        alert("CEP não encontrado.");
    }
}
function pesquisacep(valor) {

    //Nova variável "cep" somente com dígitos.
    var cep = valor.replace(/\D/g, '');

    //Verifica se campo cep possui valor informado.
    if (cep != "") {

        //Expressão regular para validar o CEP.
        var validacep = /^[0-9]{8}$/;

        //Valida o formato do CEP.
        if(validacep.test(cep)) {

            //Preenche os campos com "..." enquanto consulta webservice.
            document.getElementById('endereco').value="...";
            document.getElementById('bairro').value="...";
            document.getElementById('cidade').value="...";
            document.getElementById('estado').value="...";
            

            //Cria um elemento javascript.
            var script = document.createElement('script');

            //Sincroniza com o callback.
            script.src = 'https://viacep.com.br/ws/'+ cep + '/json/?callback=meu_callback';

            //Insere script no documento e carrega o conteúdo.
            document.body.appendChild(script);

        } //end if.
        else {
            //cep é inválido.
            limpa_formulário_cep();
            alert("Formato de CEP inválido.");
        }
    } //end if.
    else {
        //cep sem valor, limpa formulário.
        limpa_formulário_cep();
    }
};</script>
</head>
<body>
	<header class="header">
		<%@ include file="../../pagina/menu.jsp"%>
	</header>

	<div class="container-fluid content mt-2">
			<div class="container-fluid form-container p-2 m-2">
			<h2 class="mb-2 p-2 text-white border bg-success p-2 rounded shadow-custom">Cadastro de Parceiros</h2>
				 <!-- Verificação de mensagem de erro no scriptlet -->
                <%
                    String Mensagem = (String) request.getAttribute("Mensagem");
               		 String Atributo = (String) request.getAttribute("Atributo");
                    if (Mensagem != null && !Mensagem.trim().isEmpty() && Atributo != null && !Atributo.trim().isEmpty()) {
                %>
                <div class="alert alert-<%= Atributo %> alert-dismissible fade show" role="alert">
  						<strong>Atenção!</strong> <%= Mensagem %>
  							<button type="button" class="close" data-dismiss="alert" aria-label="Close">
   									 <span aria-hidden="true">&times;</span>
 								 </button>
				</div>
                <%
                    }
                %>
				<form method="post" action="/agro/ControllerParceiro" id="cadastroForm" class="needs-validation" novalidate>
							<div class="card m-3  mb-5 bg-white">
							<h3 class="card-header text-white bg-success">Dados Pessoais</h3>
							<div class="card-body">
								<div class="row">
									<!-- Nome Pessoa -->
									<div class="col-12 form-group">
										<label for="nomepessoa">Nome Completo:</label>
										 <input type="text" class="form-control" id="nomepessoa" name="nomepessoa" required>
										<div class="invalid-feedback">O nome não pode ser vazio.</div>
									</div>
								</div>
								<div class="row">
									<!-- Usuário Pessoa -->
									<div class="col-md-4 form-group">
										<label for="usuariopessoa">Usuário:</label>
										 <input type="text" class="form-control" id="usuariopessoa" name="usuariopessoa" required>
										<div class="invalid-feedback">O nome de usuário não pode ser vazio.</div>
									</div>
									<!-- Senha Pessoa -->
									<div class="col-md-4 form-group">
										<label for="senhapessoa">Senha:</label>
										 <input type="password" class="form-control" id="senhapessoa" name="senhapessoa"  required>
										<div class="invalid-feedback">A senha deve ter pelo menos 6 caracteres.</div>
									</div>
									<!-- Nível Pessoa -->
									<div class="col-md-4 form-group">
										<label for="nivelpessoa">Nível:</label> 
										<input type="text" class="form-control" id="nivelpessoa" name="nivelpessoa" value="Parceiro"readonly>
										<div class="invalid-feedback">O nível não pode ser vazio.</div>
									</div>
								</div>
								<div class="row">
									<!-- Email Pessoa -->
									<div class="col-md-12 form-group">
										<label for="emailpessoa">Email:</label> 
										<input type="email" class="form-control" id="emailpessoa" name="emailpessoa" required>
										<div class="invalid-feedback">Informe um email válido.</div>
									</div>
								</div>
								<div class="row">
									<!-- Situação Pessoa -->
									<div class="col-md-6 form-group">
										<label for="situacaopessoa">Situação:</label> 
										<select class="form-control" id="situacaopessoa" name="situacaopessoa" required>
											
											<option  value="true">Ativo</option>
											<option value="false">Desativo</option>
										</select>
										<div class="invalid-feedback">A situação não pode ser vazia.</div>
									</div>
									<!-- Telefone Pessoa -->
									<div class="col-md-6 form-group">
										<label for="telefonepessoa">Telefone:</label>
										 <input	type="text" class="form-control" id="telefonepessoa" name="telefonepessoa" required>
										<div class="invalid-feedback">O telefone não pode ser vazio.</div>
									</div>
								</div>
							</div>
						</div>
						<div class="card m-3  mb-5 bg-white">
							<h3 class="card-header text-white bg-success ">Dados da Empresas Parceira</h3>
							<div class="card-body">
								<div class="row">
									<!-- Razão Social -->
									<div class="col-md-12 form-group">
										<label for="razaoSocialPessoaCnpj">Razão Social:</label> 
										<input type="text" class="form-control" id="razaoSocialPessoaCnpj" name="razaoSocialPessoaCnpj" required>
										<div class="invalid-feedback">A razão social não pode ser vazia.</div>
									</div>
								</div>
								<div class="row">
									<!-- CNPJ Pessoa -->
									<div class="col-md-6 form-group">
										<label for="cnpjPessoaCnpj">CNPJ:</label>
										 <input type="text" class="form-control" id="cnpjPessoaCnpj" name="cnpjPessoaCnpj" required>
										<div class="invalid-feedback">O CNPJ não pode ser vazio.</div>
									</div>

									<!-- Inscrição Estadual -->
									<div class="col-md-6 form-group">
										<label for="inscricaoEstadualPessoaCnpj">Inscrição Estadual:</label> 
										<input type="text" class="form-control" id="inscricaoEstadualPessoaCnpj" name="inscricaoEstadualPessoaCnpj" required>
										<div class="invalid-feedback">A inscrição estadual não	pode ser vazia.</div>
									</div>
								</div>
								<div class="row">
									<!-- Site Parceiro -->
									<div class="col-md-8 form-group">
										<label for="siteparceiro">Site do Parceiro:</label>
										 <input type="text" class="form-control" id="siteparceiro" name="siteparceiro" required>
										<div class="invalid-feedback">O site não pode ser vazio.</div>
									</div>
								</div>
							</div>
						</div>
						<div class="card m-3  mb-5 bg-white">
							<h3 class="card-header text-white bg-success">Endereço</h3>
							<div class="card-body">
								<div class="row">
									<!-- CEP -->
									<div class="col-md-4 form-group">
										<label for="cep">CEP:</label> 
										<input type="text" class="form-control" id="cep" name="cep"  size="10" maxlength="9" onblur="pesquisacep(this.value);"  required>
										<div class="invalid-feedback">O CEP não pode ser vazio.</div>
									</div>
								</div>
								<div class="row">
									<!-- Endereço -->
									<div class="col-md-12 form-group">
										<label for="endereco">Endereço:</label> <input type="text" class="form-control" id="endereco" name="endereco" required>
										<div class="invalid-feedback">O endereço não pode servazio.</div>
									</div>
								</div>
								<div class="row">
									<!-- Número -->
									<div class="col-md-4 form-group">
										<label for="numero">Número:</label> <input type="text" class="form-control" id="numero" name="numero" required>
										<div class="invalid-feedback">O número não pode ser vazio.</div>
									</div>
									<!-- Complemento -->
									<div class="col-md-8 form-group">
										<label for="complemento">Complemento:</label> 
										<input type="text" class="form-control" id="complemento" name="complemento">
									</div>
								</div>

								<div class="row">
									<!-- Bairro -->
									<div class="col-md-6 form-group">
										<label for="bairro">Bairro:</label>
										 <input type="text" class="form-control" id="bairro" name="bairro" required>
										<div class="invalid-feedback">O bairro não pode ser vazio.</div>
									</div>

									<!-- Cidade -->
									<div class="col-md-6 form-group">
										<label for="cidade">Cidade:</label> 
										<input type="text" class="form-control" id="cidade" name="cidade" required>
										<div class="invalid-feedback">A cidade não pode ser vazia.</div>
									</div>

								</div>

								<div class="row">

									<!-- Estado -->
									<div class="col-md-6 form-group">
										<label for="estado">Estado:</label> 
										<input type="text" class="form-control" id="estado" name="estado" required>
										<div class="invalid-feedback">O estado não pode ser vazio.</div>
									</div>
									<!-- País -->
									<div class="col-md-6 form-group">
										<label for="pais">País:</label> 
										<input type="text" class="form-control" id="pais" name="pais" required>
										<div class="invalid-feedback">O país não pode ser vazio.</div>
									</div>
								</div>
							</div>
						</div>
						<!-- Botão de Enviar -->
						<div class="form-group text-center m-2">
						  <input type="hidden"   name="acao" value="create">
							<button type="submit" class="btn btn-primary btn-block btn1 mb-1">Cadastrar</button>
						</div>
				</form>
			</div>
	
	</div>
	<!-- Scripts -->
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
	<script
		src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.bundle.min.js"></script>
	<script>
        // Máscaras de entrada
        $(document).ready(function() {
            $('#telefonepessoa').mask('(00) 00000-0000');
            $('#cnpjPessoaCnpj').mask('00.000.000/0000-00');
            $('#inscricaoEstadualPessoaCnpj').mask('000.000.000.000');
            $('#cep').mask('00000-000');
        });

        // Validação de formulário Bootstrap
        (function() {
            'use strict';
            window.addEventListener('load', function() {
                var forms = document.getElementsByClassName('needs-validation');
                Array.prototype.filter.call(forms, function(form) {
                    form.addEventListener('submit', function(event) {
                        if (form.checkValidity() === false) {
                            event.preventDefault();
                            event.stopPropagation();
                        }
                        form.classList.add('was-validated');
                    }, false);
                });
            }, false);
        })();
        
    </script>
	<footer>
		<%@ include file="../../pagina/footer.jsp"%>
	</footer>
</body>
</html>
