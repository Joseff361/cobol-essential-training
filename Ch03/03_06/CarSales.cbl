       IDENTIFICATION DIVISION.
       PROGRAM-ID. CARSALES.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
       SELECT CARSALESFILE ASSIGN TO "CARSALES.DAT"
		   ORGANIZATION IS LINE SEQUENTIAL.
       SELECT CARSALESREPORT ASSIGN TO "CARSALESREPORT.DAT" 
           ORGANIZATION IS LINE SEQUENTIAL.
             
               
       DATA DIVISION.
       FILE SECTION.
       FD CARSALESFILE.
	   01 SALESDETAILS.
			88 ENDOFSALESFILE VALUE HIGH-VALUES.
			02 SALESPERSONNAME.
			   05  LASTNAME     PIC X(15).
			   05  FIRSTNAME    PIC X(10).
			02 NUMBER-OF-RECS REDEFINES SALESPERSONNAME.
               05  NUM-RECORDS  PIC 99999.
               05  FILLER       PIC X(20).
			02 QUARTERLYSALES.
			   05  Q1-SALES		PIC 9(7).
			   05  Q2-SALES		PIC 9(7).
			   05  Q3-SALES		PIC 9(7).
			   05  Q4-SALES		PIC 9(7).
            02 CARTOTAL  	    PIC 9(3).
            02 ADJUSTMENT       PIC S9(7).
	   FD CARSALESREPORT.
            01 PRINT-LINE       PIC X(132).

       WORKING-STORAGE SECTION.
       01  WS-FIELDS.
           05  WS-COUNT         PIC 99999 VALUE ZEROES.
       01  WS-DATE.
           05  WS-YEAR          PIC 99.
           05  WS-MONTH         PIC 99.
           05  WS-DAY           PIC 99.
       01  WS-QUARTERLYSALES.
           05  WS-Q1-SALES		PIC 9(8) VALUE ZEROES.
           05  WS-Q2-SALES		PIC 9(8) VALUE ZEROES.
           05  WS-Q3-SALES		PIC 9(8) VALUE ZEROES.
           05  WS-Q4-SALES		PIC 9(8) VALUE ZEROES.
       01  WS-CAR-SALES.
	       05  WS-SALESPERSON-YEARLY PIC 9(10) VALUE ZEROES.
		   05  WS-YEARLY-SALES       PIC 9(12) VALUE ZEROES.
		   05  WS-CAR-PRICE-AVERAGE  PIC 9(12).
		   05  WS-TOTAL-CAR-SALES    PIC 9999 VALUE ZEROES.
		   05  WS-DISPLAY-AVERAGE    PIC $$$,$$$,$$$.99.
		   05  WS-CARS-MINUS-10      PIC 9(4).
		   
       01  HEADING-LINE.

            05 FILLER	        PIC X(16) VALUE 'SALESPERSON NAME'.
            05 FILLER	        PIC X(20) VALUE SPACES.
            05 FILLER	        PIC X(11)  VALUE 'QTR 1 SALES'.
            05 FILLER	        PIC X(2) VALUE SPACES.
            05 FILLER	        PIC X(11)  VALUE 'QTR 2 SALES'.
            05 FILLER	        PIC X(2) VALUE SPACES.
            05 FILLER	        PIC X(11)  VALUE 'QTR 3 SALES'.
            05 FILLER	        PIC X(2) VALUE SPACES.
            05 FILLER	        PIC X(11)  VALUE 'QTR 4 SALES'.
            05 FILLER	        PIC X(4) VALUE SPACES.
            05 FILLER 	        PIC X(12) VALUE 'YEARLY SALES'.
            05 FILLER	        PIC X(37) VALUE SPACES.
			
		01  DETAIL-LINE.
			05 FILLER           PIC X(5)  VALUE SPACES.
			05 DET-FNAME        PIC X(10).
			05 FILLER           PIC X(5)  VALUE SPACES.
			05 DET-LNAME        PIC X(15).
			05 FILLER           PIC X(1)  VALUE SPACES.
			05 DET-Q1-SALES     PIC $$,$$$,$$9.
			05 FILLER           PIC X(3)  VALUE SPACES.
			05 DET-Q2-SALES     PIC $$,$$$,$$9.
			05 FILLER           PIC X(3)  VALUE SPACES.
			05 DET-Q3-SALES     PIC $$,$$$,$$9.
			05 FILLER           PIC X(3)  VALUE SPACES.
			05 DET-Q4-SALES     PIC $$,$$$,$$9.
			05 FILLER           PIC X(3)  VALUE SPACES.
			05 DET-YEARLYSALES  PIC $$,$$$,$$$,$$9.
			05 FILLER           PIC X(19)  VALUE SPACES.
			
		01  DETAIL-TOTAL-LINE1.
			05 FILLER           PIC X(5)  VALUE SPACES.
			05 FILLER           PIC X(10).
			05 FILLER           PIC X(5)  VALUE SPACES.
			05 FILLER           PIC X(15).
			05 FILLER           PIC X(1)  VALUE SPACES.
            05 FILLER           PIC X(10) VALUE "==========".
            05 FILLER           PIC X(3)  VALUE SPACES.
            05 FILLER           PIC X(10) VALUE "==========".
            05 FILLER           PIC X(3)  VALUE SPACES.
            05 FILLER           PIC X(10) VALUE "==========".
            05 FILLER           PIC X(3)  VALUE SPACES.
            05 FILLER           PIC X(10) VALUE "==========".
            05 FILLER           PIC X(7)  VALUE SPACES.
            05 FILLER           PIC X(10) VALUE "==========".
            05 FILLER           PIC X(19)  VALUE SPACES.
			
		01  DETAIL-TOTAL-LINE.
			05 FILLER           PIC X(5)  VALUE SPACES.
			05 FILLER           PIC X(10).
			05 FILLER           PIC X(5)  VALUE SPACES.
			05 FILLER           PIC X(15)  VALUE "TOTALS: ".
			05 FILLER           PIC X(1)  VALUE SPACES.
			05 DET-Q1-TOT-SALES PIC $$,$$$,$$9.
			05 FILLER           PIC X(3)  VALUE SPACES.
			05 DET-Q2-TOT-SALES PIC $$,$$$,$$9.
			05 FILLER           PIC X(3)  VALUE SPACES.
			05 DET-Q3-TOT-SALES PIC $$,$$$,$$9.
			05 FILLER           PIC X(3)  VALUE SPACES.
			05 DET-Q4-TOT-SALES PIC $$,$$$,$$9.
			05 FILLER           PIC X(3)  VALUE SPACES.
			05 DET-TOT-YEARLYSALES  PIC $$,$$$,$$$,$$9.
			05 FILLER           PIC X(19)  VALUE SPACES.						
			
       PROCEDURE DIVISION.
       0100-OPENFILE.
           OPEN INPUT CARSALESFILE.
           OPEN OUTPUT CARSALESREPORT.
		   WRITE PRINT-LINE FROM HEADING-LINE AFTER 
              ADVANCING 1 LINE.

        READ CARSALESFILE
			    AT END SET ENDOFSALESFILE TO TRUE
			    END-READ.
       IF(ENDOFSALESFILE)
           GO TO 0900-STOP-RUN.
		   PERFORM 0200-PROCESS-SALES NUM-RECORDS TIMES.
           PERFORM 0300-PROCESS-TOTALS.
           PERFORM 0900-STOP-RUN.
		   
       0200-PROCESS-SALES.
   		READ CARSALESFILE INTO SALESDETAILS.    
			MOVE FIRSTNAME TO DET-FNAME.
			MOVE LASTNAME TO DET-LNAME.
			MOVE Q1-SALES TO DET-Q1-SALES.
			MOVE Q2-SALES TO DET-Q2-SALES.
			MOVE Q3-SALES TO DET-Q3-SALES.
			MOVE Q4-SALES TO DET-Q4-SALES.
			
			ADD Q1-SALES TO WS-Q1-SALES, 
			   WS-SALESPERSON-YEARLY.
			ADD Q2-SALES TO WS-Q2-SALES, 
			   WS-SALESPERSON-YEARLY.
			ADD Q3-SALES TO WS-Q3-SALES, 
			   WS-SALESPERSON-YEARLY.
            ADD Q4-SALES TO WS-Q4-SALES, 
			   WS-SALESPERSON-YEARLY.
            MOVE WS-SALESPERSON-YEARLY TO DET-YEARLYSALES.
			ADD WS-SALESPERSON-YEARLY TO WS-YEARLY-SALES.
			MOVE ZEROES TO WS-SALESPERSON-YEARLY.
			WRITE PRINT-LINE FROM DETAIL-LINE AFTER 
               ADVANCING 1 LINE.

		0300-PROCESS-TOTALS.	

			MOVE WS-Q1-SALES TO DET-Q1-TOT-SALES.
			MOVE WS-Q2-SALES TO DET-Q2-TOT-SALES.
			MOVE WS-Q3-SALES TO DET-Q3-TOT-SALES.
			MOVE WS-Q4-SALES TO DET-Q4-TOT-SALES.
			MOVE WS-YEARLY-SALES TO DET-TOT-YEARLYSALES.
			WRITE PRINT-LINE FROM DETAIL-TOTAL-LINE1 AFTER 
               ADVANCING 2 LINES.
			WRITE PRINT-LINE FROM DETAIL-TOTAL-LINE AFTER 
               ADVANCING 2 LINES.
		
        0900-STOP-RUN.
     		 CLOSE CARSALESFILE, CARSALESREPORT.	       
             STOP RUN.
           
          END PROGRAM CARSALES.
