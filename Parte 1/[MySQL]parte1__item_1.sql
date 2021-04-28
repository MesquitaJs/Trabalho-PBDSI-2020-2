
/*--------------------------------------------------------------------------------------------------*
  			TRABALHO PROJETO DE BANCO DE DADOS PARA SI 2020.2                                   
							BASE DE DADOS: MySQL                                                    
												                            						
									PARTE 1:                              							
                        																			
						ITEM 1 - Consultar as tabelas de catálogo									
								 para listar todos os índices existentes
								 acompanhados das tabelas e colunas indexadas pelo mesmo.					
																									
                                                           										
   Querys usadas para verifcar o conteúdo do catálogo e para aprender a usá-lo:					
																									
		-- select * from information_schema.STATISTICS;                                             
		-- select * from information_schema.STATISTICS where TABLE_SCHEMA = "chinook";              
		-- select TABLE_NAME from information_schema.STATISTICS where TABLE_SCHEMA = "chinook";     
       -- select COLUMN_NAME from information_schema.STATISTICS where TABLE_SCHEMA = "chinook";    
       -- select INDEX_NAME from information_schema.STATISTICS where TABLE_SCHEMA = "chinook";     
-------------------------------------------------------------------------------------------------------*/


/*ITEM 1 RESPOSTA: */
USE Chinook;

SELECT DISTINCT TABLE_NAME AS NOME_TABELA, COLUMN_NAME AS NOME_COLUNA, INDEX_NAME AS NOME_INDICE
FROM information_schema.STATISTICS
WHERE TABLE_SCHEMA = "chinook";
