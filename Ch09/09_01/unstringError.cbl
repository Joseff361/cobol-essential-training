       IDENTIFICATION DIVISION.
       PROGRAM-ID. UNSTRINGADDRESS.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
	   SELECT CUSTOMERSCSV ASSIGN TO "Customers.csv"
		 ORGANIZATION IS LINE SEQUENTIAL.
	
       SELECT MAILINGREPORT ASSIGN TO "mailing.lpt"
         ORGANIZATION IS LINE SEQUENTIAL.	   
                       
       DATA DIVISION.
       FILE SECTION.
	   FD CUSTOMERSCSV.
	   01 CUSTOMERSIN.
			88 ENDOFFILE VALUE HIGH-VALUES.
			02 CUSTDETAILS     PIC X(61).
		
       FD MAILINGREPORT.
       01 CUSTOMERSOUT.
	       05  MAILINGREC     PIC X(26).
			
       WORKING-STORAGE SECTION.   
	   01  WS-WORKING-STORAGE.
	       05  FILLER  PIC X(27) VALUE 
		       'WORKING STORAGE STARTS HERE'.
		
           05  WS-LASTNAME     PIC X(10).
           05  WS-FIRSTNAME    PIC X(10).
		   05  WS-HOUSENUM     PIC X(5).
		   05  WS-STREETNAME   PIC X(20).
           05  WS-CITY         PIC X(15). 
		   05  WS-STATE        PIC X(2).
		   05  WS-ZIP          PIC X(5).
           05  WS-EMAIL        PIC X(39).
		   
           05  STRINGEND       PIC 99.	

           05  WS-FULLNAME     PIC X(26).
           05  WS-ADDRESSLINE  PIC X(26).
           05  WS-CITYLINE     PIC X(26).  

       PROCEDURE DIVISION.
       
	   0100-BEGIN.
		    
		   OPEN INPUT CUSTOMERSCSV.
		   OPEN OUTPUT MAILINGREPORT.
	
		   READ CUSTOMERSCSV
			AT END SET ENDOFFILE TO TRUE
			END-READ.
		  		   
           PERFORM 0200-PROCESS-RECORDS UNTIL ENDOFFILE.
		 
		   PERFORM 0300-STOP-RUN.
	   
	   0200-PROCESS-RECORDS.
	       
		   PERFORM VARYING STRINGEND FROM 61 BY -1
              UNTIL CUSTDETAILS(STRINGEND:1) NOT = SPACE
		   END-PERFORM.
			  
           UNSTRING CUSTOMERSIN(1:STRINGEND) DELIMITED BY ","
             INTO WS-LASTNAME
			      WS-FIRSTNAME
				  WS-HOUSENUM
				  WS-STREETNAME
				  WS-CITY
				  WS-STATE
				  WS-ZIP
                  WS-EMAIL
           END-UNSTRING.
		   
           MOVE SPACES TO WS-FULLNAME, WS-ADDRESSLINE, 
           WS-CITYLINE.
           STRING WS-FIRSTNAME DELIMITED BY ' ' SPACE 
             WS-LASTNAME DELIMITED BY SIZE INTO WS-FULLNAME.
           STRING WS-HOUSENUM DELIMITED BY ' ' SPACE 
             WS-STREETNAME DELIMITED BY SIZE INTO 
             WS-ADDRESSLINE.
           STRING WS-CITY DELIMITED BY ' ' ',' SPACE WS-STATE 
             DELIMITED BY ' ' SPACE WS-ZIP INTO WS-CITYLINE.
		
		   WRITE CUSTOMERSOUT FROM WS-FULLNAME.
           WRITE CUSTOMERSOUT FROM WS-ADDRESSLINE.
           WRITE CUSTOMERSOUT FROM WS-CITYLINE.
           WRITE CUSTOMERSOUT FROM ' '.
		   READ CUSTOMERSCSV 
			 AT END SET ENDOFFILE TO TRUE
		   END-READ.
	   
	   0200-END.
	   
	   0300-STOP-RUN.	
		
           CLOSE CUSTOMERSCSV, MAILINGREPORT.		
           STOP RUN.
           
          END PROGRAM UNSTRINGADDRESS.