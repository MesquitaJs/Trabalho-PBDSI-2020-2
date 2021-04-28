/*-------------------------------------------------------------------------------------------------------------
				TRABALHO PROJETO DE BANCO DE DADOS PARA SI 2020.2                                   
							BASE DE DADOS: MySQL                                                    
												                            						
									PARTE 1:                              							
                        														
						ITEM 2 - Criar usando a linguagem de programação do SGBD                
                                  escolhido um procedimento que remova todos os                 
                                índices de uma tabela informada como parâmetro.	                																									*
                                                           										
   Querys usadas para verifcar o conteúdo do catálogo e para aprender a usá-lo:					
																								
	  (1)   Select TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE
			from information_schema.TABLE_CONSTRAINTS
			WHERE CONSTRAINT_SCHEMA = 'chinook';
	  
	  (2)	SELECT DISTINCT TABLE_NAME AS NOME_TABELA, COLUMN_NAME AS NOME_COLUNA, INDEX_NAME AS NOME_INDICE
			FROM information_schema.STATISTICS
			WHERE TABLE_SCHEMA = "chinook";

	  
	  (3) 	SELECT tb.CONSTRAINT_NAME, st.INDEX_NAME, tb.TABLE_NAME
			FROM information_schema.TABLE_CONSTRAINTS tb
			LEFT OUTER JOIN information_schema.STATISTICS st ON tb.CONSTRAINT_SCHEMA = st.INDEX_SCHEMA
			WHERE RIGHT(st.INDEX_NAME, char_length(tb.CONSTRAINT_NAME)) = tb.CONSTRAINT_NAME AND
			st.index_name <> 'PRIMARY' AND st.TABLE_NAME = 'track';         
------------------------------------------------------------------------------------------------------------*/

/*ITEM 2 - resposta: */

USE Chinook;
DROP PROCEDURE IF EXISTS dropIndex;

delimiter //
create procedure dropIndex(IN param_table_name varchar(255))
begin
	-- contador para contar o nº de constraints
	declare cont int default 0;
    
    declare done int default FALSE;
    declare dropCommand varchar(255);
    
     --  cursor para remover INDICES
    declare dropIdxCur cursor for
		SELECT CONCAT('ALTER TABLE ',param_table_name,' DROP INDEX ', index_name,';') 
        FROM information_schema.statistics
        WHERE  index_name <> 'PRIMARY' 
            AND table_name = param_table_name AND table_schema = 'chinook';
     
		/*
			Para remover um indice é preciso remover a FK associada a ele.
		 No CHINOOK, a diferença entre uma CONSTRAINT_NAME(FK) e um INDEX_NAME é que o
         INDEX_NAME TEM UM 'I' no inicio do nome. Ex.: FK_TrackAlbumId e IFK_TrackAlbumId.
         */
         
     -- Cursor para remover somente as FOREIGN KEYS associada a um INDICE 
	declare dropFKCur cursor for 
		SELECT CONCAT('ALTER TABLE ',param_table_name,' DROP FOREIGN KEY ', tb.CONSTRAINT_NAME,';')
		FROM information_schema.TABLE_CONSTRAINTS tb
        LEFT OUTER JOIN information_schema.STATISTICS st ON tb.CONSTRAINT_SCHEMA = st.INDEX_SCHEMA
		WHERE RIGHT(st.INDEX_NAME, char_length(tb.CONSTRAINT_NAME)) = tb.CONSTRAINT_NAME AND
         st.index_name <> 'PRIMARY' AND st.TABLE_NAME = param_table_name;
    
    -- continue handler    
    declare continue handler for not found set done = true;
    
    -- contador de constraints
	SELECT count(*) into cont 
        FROM information_schema.TABLE_CONSTRAINTS tb
        LEFT OUTER JOIN information_schema.STATISTICS st ON tb.CONSTRAINT_SCHEMA = st.INDEX_SCHEMA
		WHERE RIGHT(st.INDEX_NAME, char_length(tb.CONSTRAINT_NAME)) = tb.CONSTRAINT_NAME AND
         st.index_name <> 'PRIMARY' AND st.TABLE_NAME = param_table_name;
      
	-- abrindo cursores  
    open dropIdxCur;
	open dropFKCur;
    
    -- iniciando loop
    idx_loop: loop
    
		-- se houver FKs associada a um indice... dropa FKs
		if (cont > 0) then 
            fetch dropFKCur into dropCommand;
            set @sdropCommand = dropCommand;
			prepare dropClientUpdateKeyStmt FROM @sdropCommand;
			execute dropClientUpdateKeyStmt;
			deallocate prepare dropClientUpdateKeyStmt;
            set cont = (cont - 1);
        end if;
        
        -- dropa indice
        fetch dropIdxCur into dropCommand;
        
        IF done then
            leave idx_loop;
        end IF;

        set @sdropCommand = dropCommand;
        prepare dropClientUpdateKeyStmt FROM @sdropCommand;
        execute dropClientUpdateKeyStmt;
        deallocate prepare dropClientUpdateKeyStmt;
    end loop;
    close dropIdxCur;
    close dropFKCur;
    
end//
delimiter ;

-- TESTES DO PROCEDURE
	-- SELECT DISTINCT TABLE_NAME, INDEX_NAME, COLUMN_NAME FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = 'Chinook' AND TABLE_NAME = 'Track';
	-- CALL dropIndex('track');
	-- SELECT DISTINCT TABLE_NAME, INDEX_NAME, COLUMN_NAME FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = 'Chinook' AND TABLE_NAME = 'Track';

	-- SELECT DISTINCT TABLE_NAME, INDEX_NAME, COLUMN_NAME FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = 'Chinook' AND TABLE_NAME = 'PlaylistTrack';
	-- CALL dropIndex('playlisttrack');
    -- SELECT DISTINCT TABLE_NAME, INDEX_NAME, COLUMN_NAME FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = 'Chinook' AND TABLE_NAME = 'PlaylistTrack';
