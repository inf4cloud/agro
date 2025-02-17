
package Dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import Model.Alimento;
import Model.Classificacao;
import util.PostgresConnection;

public class AlimentoDAO {
	
	/*Metodo de retorno de proximo serial*/
	
  public int RetornoIdAlimento() throws SQLException {
    PostgresConnection conn = new PostgresConnection();
    Connection conexao = conn.getConnection();
    int proximoId = -1; // Variável para armazenar o próximo valor da sequência

    try {
        String sql = "SELECT nextval(pg_get_serial_sequence('alimento', 'idalimento')) AS proximoId;";
        PreparedStatement stmt = conexao.prepareStatement(sql);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            proximoId = rs.getInt("proximoId"); // Obtém o valor do próximo ID
        }
    } catch (SQLException e) {
        System.out.println("Erro ao obter próximo ID: " + e.getMessage());
    } finally {
        // Fecha a conexão
        if (conexao != null) {
            conexao.close();
        }
    }
    return proximoId;
}
  
  /*Cadastro  de Alimento*/
  
  public void CadastroAlimento(Alimento alimento) throws SQLException {
      PostgresConnection conn = new PostgresConnection();
      Connection conexao= conn.getConnection();
      try  {
      	String sql = "INSERT INTO alimento (nomealimento,  variedadealimento) VALUES (?,?)";
      	 PreparedStatement ptmt= conexao.prepareStatement(sql);
              ptmt.setString(1, alimento.getAlimento());
              ptmt.setString(2, alimento.getVariedade());
              ptmt.executeUpdate();
      }catch (SQLException e) {
          System.out.println("Erro no cadastro: "+e.getMessage());
		}
      conexao.close();
  }
  
/*Atualizacao  de Alimento*/
  
  public void AtualizacaoAlimento(Alimento alimento) throws SQLException {
      PostgresConnection conn = new PostgresConnection();
      Connection conexao= conn.getConnection();
      try  {
    	  String sql = "UPDATE alimento SET nomealimento = ?,  variedadealimento = ? WHERE idalimento = ?";
      	 PreparedStatement ptmt= conexao.prepareStatement(sql);
              ptmt.setString(1, alimento.getAlimento());
              ptmt.setString(2, alimento.getVariedade());
              ptmt.setInt(3, alimento.getIdalimento());
              ptmt.executeUpdate();
      }catch (SQLException e) {
          System.out.println("Erro no cadastro: "+e.getMessage());
		}
      conexao.close();
  }
  
  /*Metodo de Verificaçao de dados existentes*/
  
	 public boolean VerificacaoAlimento(Alimento alimento) throws SQLException {
		 PostgresConnection conn = new PostgresConnection();
		 Connection conexao= conn.getConnection();
		 
	        boolean existe = false;

	        
	        try {
	        	 String sql = "SELECT COUNT(*) FROM alimento WHERE nomealimento = ? and  variedadealimento =?";
	             PreparedStatement stmt = conexao.prepareStatement(sql);
	             // Definindo o valor do parâmetro da consulta
	             stmt.setString(1, alimento.getAlimento());
	             stmt.setString(2, alimento.getVariedade());
	             ResultSet rs = stmt.executeQuery();
	             if (rs.next()) {
	                    // Verificando se a contagem é maior que zero
	                    existe = rs.getInt(1)>0;
	                }


	        } catch (SQLException e) {
	        	e.printStackTrace();
	            System.out.println("Erro no nivel dao: "+e.getMessage()); // Tratar exceções de forma adequada na sua aplicação
	        }
    
	        return existe;
	    }
	 
	 /* Listando todos os dados de alimentos*/
	 public List<Alimento> listAll() throws SQLException {
    	 PostgresConnection conn = new PostgresConnection();
         Connection conexao= conn.getConnection();
            List<Alimento> alimentos = new ArrayList<>();
                       try {
            	String sql = "SELECT * FROM alimento";
            	PreparedStatement stmt = conexao.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                	
                	 Alimento alimento = new Alimento();
                	 
                	 alimento.setIdalimento(rs.getInt("idalimento"));
                	 alimento.setAlimento(rs.getString("nomealimento"));
                	 alimento.setAlimento(rs.getString("variedadealimento"));
                    
                	 alimentos.add(alimento);
                }
                conexao.close();
                } catch (SQLException e) {
                    System.out.println("Erro no cadastro: "+e.getMessage());
			} 
		        return alimentos;
    }
}



