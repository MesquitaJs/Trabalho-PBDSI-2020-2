
/*-----------------------------------------------------------------------------------------------------------------------------*
  			TRABALHO PROJETO DE BANCO DE DADOS PARA SI 2020.2                                   
							BASE DE DADOS: MySQL                                                    
												                            						
									PARTE 1:                              							
                        																			
						ITEM 3 - Consultar as tabelas de catálogo para listar todas as
						chaves estrangeiras existentes informando as tabelas e colunas envolvidas.					
																									
                                                           										
   Querys usadas para verifcar o conteúdo do catálogo e para aprender a usá-lo:					
																									
		 -- consultas na tabela information_schema.TABLE_CONSTRAINTS:
			-- select * from information_schema.TABLE_CONSTRAINTS;
			-- select * from information_schema.TABLE_CONSTRAINTS WHERE CONSTRAINT_SCHEMA = 'chinook';
			
			/*select TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE
			from information_schema.TABLE_CONSTRAINTS
			WHERE CONSTRAINT_SCHEMA = 'chinook'; */
			
			/*select TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE
			from information_schema.TABLE_CONSTRAINTS
			WHERE CONSTRAINT_SCHEMA = 'chinook'AND CONSTRAINT_TYPE = 'FOREIGN KEY'; */
					
	-- consultas na tabela information_schema.KEY_COLUMN_USAGE:
		-- select * from information_schema.KEY_COLUMN_USAGE;
		-- select * from information_schema.KEY_COLUMN_USAGE WHERE CONSTRAINT_SCHEMA = 'chinook';
		
		/*select COLUMN_NAME, REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME
		 from information_schema.KEY_COLUMN_USAGE WHERE CONSTRAINT_SCHEMA = 'chinook'; */
------------------------------------------------------------------------------------------------------------------------------*/

	/* ITEM 3 -  RESPOSTA: */

		USE Chinook;

		SELECT TABLE_NAME AS NOME_TABELA,
			COLUMN_NAME AS NOME_COLUNA,
			CONSTRAINT_NAME AS FOREIGN_KEY,
			REFERENCED_TABLE_NAME AS NOME_TABELA_REFERENCIADA,
			REFERENCED_COLUMN_NAME AS  NOME_COLUNA_REFERENCIADA
		FROM information_schema.KEY_COLUMN_USAGE
		WHERE CONSTRAINT_SCHEMA = 'chinook'and REFERENCED_COLUMN_NAME is NOT NULL;

	/* ITEM 3 -  RESPOSTA: QUERY ALTERNATIVA: JOIN das tablas TABLE_CONSTRAINTS e KEY_COLUMN_USAGE*/
	
	/*
		SELECT tc.TABLE_NAME AS NOME_TABELA,
			kcu.COLUMN_NAME AS NOME_COLUNA,
			tc.CONSTRAINT_NAME AS FOREIGN_KEY,
			kcu.REFERENCED_TABLE_NAME AS NOME_TABELA_REFERENCIADA,
			kcu.REFERENCED_COLUMN_NAME AS NOME_COLUNA_REFERENCIADA
		FROM information_schema.TABLE_CONSTRAINTS tc INNER JOIN information_schema.KEY_COLUMN_USAGE kcu
			ON tc.CONSTRAINT_NAME = kcu.CONSTRAINT_NAME
		WHERE kcu.CONSTRAINT_SCHEMA = 'chinook'
			AND tc.CONSTRAINT_TYPE = 'FOREIGN KEY' AND  tc.TABLE_SCHEMA = 'chinook';                                                                           
*/