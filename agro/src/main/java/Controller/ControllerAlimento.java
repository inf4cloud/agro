/*
 * package Controller;
 * 
 * import com.google.gson.Gson; import com.google.gson.JsonObject;
 * 
 * import Dao.AlimentoDAO; import Dao.EnderecoDAO; import Dao.ParceiroDAO;
 * 
 * import java.io.BufferedReader; import java.io.IOException; import
 * java.util.List;
 * 
 * import jakarta.servlet.ServletException; import
 * jakarta.servlet.annotation.WebServlet; import
 * jakarta.servlet.http.HttpServlet; import
 * jakarta.servlet.http.HttpServletRequest; import
 * jakarta.servlet.http.HttpServletResponse;
 * 
 * @WebServlet("/ControllerAlimento") public class ControllerAlimento extends
 * HttpServlet { private static final long serialVersionUID = 1L; private
 * AlimentoDAO alimentodao; String Caminho= "view/admin/"; String Mensagem ="";
 * String Atributo = "";
 * 
 * 
 * public void init() { alimentodao = new AlimentoDAO(); }
 * 
 * public ControllerAlimento() { super(); }
 * 
 * @SuppressWarnings("unchecked") protected void doPost(HttpServletRequest
 * request, HttpServletResponse response) throws ServletException, IOException {
 * // Lendo o corpo da requisição JSON StringBuilder json = new StringBuilder();
 * try (BufferedReader reader = request.getReader()) { String linha; while
 * ((linha = reader.readLine()) != null) { json.append(linha); } }
 * 
 * // Convertendo o JSON em um objeto Gson gson = new Gson(); JsonObject
 * jsonObject = gson.fromJson(json.toString(), JsonObject.class);
 * 
 * // Extraindo a ação do JSON String acao =
 * jsonObject.get("acao").getAsString();
 * 
 * if ("create".equals(acao)) { try { // Extraindo os demais parâmetros do JSON
 * String alimento = jsonObject.get("alimento").getAsString(); String variedade
 * = jsonObject.get("variedade").getAsString(); List<String> classificacoes =
 * gson.fromJson(jsonObject.get("classificacoes"), List.class);
 * 
 * // Logs para depuração System.out.println("Ação: " + acao);
 * System.out.println("Alimento: " + alimento); System.out.println("Variedade: "
 * + variedade); System.out.println("Classificações: " + classificacoes);
 * 
 * int numero= alimentodao.RetornoIdAlimento(); System.out.println("numero: " +
 * numero); // Processar os dados (exemplo: salvar no banco de dados)
 * 
 * // Resposta de sucesso response.setContentType("application/json");
 * response.getWriter().
 * write("{\"message\": \"Alimento cadastrado com sucesso!\"}"); } catch
 * (Exception e) { // Tratamento de erros e.printStackTrace();
 * response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
 * response.getWriter().
 * write("{\"message\": \"Erro ao processar a solicitação\"}"); } } else { //
 * Resposta para ações inválidas
 * response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
 * response.getWriter().write("{\"message\": \"Ação não suportada!\"}"); } } }
 */
package Controller;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import Dao.AlimentoDAO;
import Dao.AlimentoClassificacaoDAO;
import Model.Alimento;
import Model.AlimentoClassificacao;
import Model.Classificacao;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ControllerAlimento")
public class ControllerAlimento extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private AlimentoDAO alimentodao;
    private AlimentoClassificacaoDAO alimentoclassificacaodao;

    String Caminho = "view/admin/";
    String Mensagem = "";
    String Atributo = "";

    public void init() {
        alimentodao = new AlimentoDAO();
        alimentoclassificacaodao = new AlimentoClassificacaoDAO();
    }

    public ControllerAlimento() {
        super();
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            List<Alimento> alimentos = alimentodao.listAll(); // Obtém a lista de alimentos
            String json = new Gson().toJson(alimentos); // Converte para JSON
            PrintWriter out = response.getWriter();
            out.print(json);
            out.flush();

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Erro ao carregar alimentos: " + e.getMessage() + "\"}");
        }
    }

    @SuppressWarnings("unchecked")
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lendo o corpo da requisição JSON
        StringBuilder json = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String linha;
            while ((linha = reader.readLine()) != null) {
                json.append(linha);
            }
        }

        // Convertendo o JSON em um objeto
        Gson gson = new Gson();
        JsonObject jsonObject = gson.fromJson(json.toString(), JsonObject.class);

        // Extraindo a ação do JSON
        String acao = jsonObject.get("acao").getAsString();

        if ("create".equals(acao)) {
            try {
            	 // Extraindo os demais parâmetros do JSON
                String alimento = jsonObject.get("alimento").getAsString();
                String variedade = jsonObject.get("variedade").getAsString();
                List<String> classificacoes = gson.fromJson(jsonObject.get("classificacoes"), List.class);

                /* Logs para depuração
                System.out.println("Ação: " + acao);
                System.out.println("Alimento: " + alimento);
                System.out.println("Variedade: " + variedade);
                System.out.println("Classificações: " + classificacoes);
                */
                Alimento alimentonew = new Alimento();
             	alimentonew.setAlimento(alimento);
             	alimentonew.setVariedade(variedade);
             	
             	//Teste de verificar se existe
             		boolean Verificaralimento= alimentodao.VerificacaoAlimento(alimentonew);	
           
             			if(Verificaralimento == true) {
             				Mensagem = "Cadastro já existente do Alimento!";
    				 		Atributo= "danger";
    				        request.setAttribute("Mensagem", Mensagem);
    				 		request.setAttribute("Atributo", Atributo);
    				        request.getRequestDispatcher(Caminho +"alimento.jsp").forward(request, response);
             			} else {
             			
             				// Realiza o cadastro de  alimento
             						alimentodao.CadastroAlimento(alimentonew);
             						
                     	// Obtém o numero do numero de registro do alimento e subtrair para menos um para obter valor correto!
                            int numero = alimentodao.RetornoIdAlimento()-1;
                          

                            // Loop para cadastrar cada classificação no banco de dados
                            for (String classificacaoId : classificacoes) {
                            	AlimentoClassificacao alimentoClassificacao = new AlimentoClassificacao();

                                /* Inicializa o objeto Alimento antes de acessá-lo criando novo instancia no dois modelo de negocio
                                 *  instancia Alimento, Classificacao
                                 *  Instancia sendo feito dentro atributooi
                                 *  */
                                alimentoClassificacao.setAlimento(new Alimento());
                                alimentoClassificacao.setClassificacao(new Classificacao());

                                // Define os valores corretamente
                                alimentoClassificacao.getAlimento().setIdalimento(numero); // Associando o ID gerado
                                alimentoClassificacao.getClassificacao().setIdclassificacao(Integer.parseInt(classificacaoId));

                                // Inserindo no banco de dados
                                alimentoclassificacaodao.saveAlimentoClassificacao(alimentoClassificacao);
                               
                            }
                            	
                     	// Resposta de sucesso
                     		Mensagem = "Cadastro Alimento com Sucesso!";
    				 		Atributo= "success";
    				        request.setAttribute("Mensagem", Mensagem);
    				 		request.setAttribute("Atributo", Atributo);
    				        request.getRequestDispatcher(Caminho +"alimento.jsp").forward(request, response);
             			}
            } catch (Exception e) {
                // Tratamento de erros
                e.printStackTrace();
                Mensagem = "Erro cadastro do Alimento!";
		 		Atributo= "danger";
		        request.setAttribute("Mensagem", Mensagem);
		 		request.setAttribute("Atributo", Atributo);
		        request.getRequestDispatcher(Caminho +"alimento.jsp").forward(request, response);
            }
        } 
        else if("update".equals(acao)) {
       	 
        	try {
        		
        		/*Declaracação de variaveis*/
        		   Alimento alimento = new Alimento();
        		   
        		   /*Atribuindo ao objeto*/
        		   
        		 alimento.setAlimento(jsonObject.get("alimento").getAsString());
                 alimento.setVariedade(jsonObject.get("variedade").getAsString());
                 alimento.setIdalimento(Integer.parseInt( jsonObject.get("idalimento").getAsString()));
                  
                 /*AlimentoDAO direcionanando*/
                 
                  alimentodao.AtualizacaoAlimento(alimento);
                  
                  /*redirecionamento*/
                  Mensagem = "Alimento Atualizado!";
  		 		Atributo= "success";
  		        request.setAttribute("Mensagem", Mensagem);
  		 		request.setAttribute("Atributo", Atributo);
  		        request.getRequestDispatcher(Caminho +"parceiro.jsp").forward(request, response);
                  
			} catch (Exception e) {
				 Mensagem = "Erro cadastro do Alimento!";
			 		Atributo= "danger";
			        request.setAttribute("Mensagem", Mensagem);
			 		request.setAttribute("Atributo", Atributo);
			        request.getRequestDispatcher(Caminho +"alimento.jsp").forward(request, response);
			}
           
                   
               

        } else if("deleteAlimentoClasiificacao".equals(acao)) {
        	try {
        		/*Declaracação de variaveis*/
        		
        		AlimentoClassificacao alimentoClassificacao = new AlimentoClassificacao();
        		
        		/*Atribuindo variaveis*/
        		
                alimentoClassificacao.setIdAlimentoClassificacao(Integer.parseInt(request.getParameter("idalimentoclassificacao")));
                
                /*Declaracao do metodo*/
                
                 alimentoclassificacaodao.DeleteAlimentoClassificacao(alimentoClassificacao);
                 
                 /* redirecionado a pagina*/
                 Mensagem = "Deletado com sucesso a classificação!";
			 	 Atributo= "success";
			        request.setAttribute("Mensagem", Mensagem);
			 		request.setAttribute("Atributo", Atributo);
			        request.getRequestDispatcher(Caminho +"alimento.jsp").forward(request, response);
                
            	
			} catch (Exception e) {
				 /* redirecionado a pagina*/
                Mensagem = "Erro em deletar a classificação";
			 		Atributo= "danger";
			        request.setAttribute("Mensagem", Mensagem);
			 		request.setAttribute("Atributo", Atributo);
			        request.getRequestDispatcher(Caminho +"alimento.jsp").forward(request, response);
			}
            
        }
        else {// Resposta para ações inválidas
        	 Mensagem = "Erro no processamento";
		 		Atributo= "danger";
		        request.setAttribute("Mensagem", Mensagem);
		 		request.setAttribute("Atributo", Atributo);
		        request.getRequestDispatcher(Caminho +"alimento.jsp").forward(request, response);
    }
    }}
