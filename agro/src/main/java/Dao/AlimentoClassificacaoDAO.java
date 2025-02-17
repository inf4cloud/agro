package Dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import Model.AlimentoClassificacao;
import util.PostgresConnection;

public class AlimentoClassificacaoDAO {
	  public void saveAlimentoClassificacao(AlimentoClassificacao alimentoclassificacao) throws SQLException {
	        PostgresConnection conn = new PostgresConnection();
	        Connection conexao= conn.getConnection();
	        try  {
	        	String sql = "INSERT INTO alimentoclassificacao (idclassificacao,idalimento) VALUES (?,?)";
	        	 PreparedStatement ptmt= conexao.prepareStatement(sql);
	                ptmt.setInt(1,  alimentoclassificacao.getClassificacao().getIdclassificacao());
	                ptmt.setInt(2,  alimentoclassificacao.getAlimento().getIdalimento());
	                ptmt.executeUpdate();
	        }catch (SQLException e) {
	            System.out.println("Erro no cadastro: "+e.getMessage());
			}
	        conexao.close();
	    }
	  public void DeleteAlimentoClassificacao(AlimentoClassificacao alimentoclassificacao) throws SQLException {
	        PostgresConnection conn = new PostgresConnection();
	        Connection conexao= conn.getConnection();
	        try  {
	        	String sql = "delete from alimentoclassificao where idalimentoclassificacao = ?";
	        	 PreparedStatement ptmt= conexao.prepareStatement(sql);
	                ptmt.setInt(1,  alimentoclassificacao.getIdAlimentoClassificacao());
	              
	                ptmt.executeUpdate();
	        }catch (SQLException e) {
	            System.out.println("Erro no cadastro: "+e.getMessage());
			}
	        conexao.close();
	    }
}
