       IDENTIFICATION DIVISION.
       PROGRAM-ID. INSPECTEMPLOYEES.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
	  SELECT EMPLOYEEFILE ASSIGN TO "EMPLOYEES.DAT"
		ORGANIZATION IS LINE SEQUENTIAL.
                       
       DATA DIVISION.
       FILE SECTION.
	   FD EMPLOYEEFILE.
	   01 EMPDETAILS.
			88 ENDOFFILE VALUE HIGH-VALUES.
			02 EMPLOYEESSN  	 PIC 9(9).
			02 EMPLOYEENAME.
				03 LASTNAME	     PIC X(10).
				03 FIRSTNAME     PIC X(10).
				03 MIDDLEINIT    PIC X.
			02 BIRTHDATE.
				03 BIRTH-YEAR	 PIC 9(4).
				03 BIRTH-MONTH	 PIC 9(2).
				03 BIRTH-DAY	 PIC 9(2).
			02 GENDER            PIC X.
            02 EMAIL             PIC X(20).
			
       WORKING-STORAGE SECTION.   
	   01  WS-WORKING-STORAGE.
	       05  FILLER  PIC X(27) VALUE 
		       'WORKING STORAGE STARTS HERE'.

       01 WS-FIELDS.
           05 WS-TALLY     PIC 9(3).
		
	     01  WS-REPORT-TITLE.
           05  FILLER     PIC X(20) VALUE SPACES.
           05  FILLER     PIC X(33) 
		        VALUE 'EMPLOYEE LIST'.		   
       01  WS-HEADING-LINE.
	       05  FILLER     PIC X(30) VALUE 'NAME'.
		   05  FILLER     PIC X(11) VALUE 'SSN'.	
           05  FILLER     PIC X(23) VALUE '   EMAIL'.
	    
       01  WS-HEADING-LINE2.
	       05  FILLER     PIC X(30) VALUE 
		        '-------------------------'.
		   05  FILLER     PIC X(11) VALUE 
		        '-----------'.
		   05  FILLER     PIC X(23) VALUE 
		        '   --------------------'.		
	   01  WS-DETAIL-LINE.
	       05  WS-DET-NAME.
		       10 WS-DET-FNAME    PIC X(10).
			   10 FILLER          PIC XX.
			   10 WS-DET-MIDDLE   PIC X.
			   10 FILLER          PIC XX.
			   10 WS-DET-LNAME    PIC X(10).
			   10 FILLER          PIC X(5).
		   05  SSN-OUT            PIC 999B99B9999.
           05  FILLER             PIC X(3).
           05  WS-DET-EMAIL       PIC X(20).
	

       PROCEDURE DIVISION.
       
	   0100-BEGIN.
		    
		   OPEN INPUT EMPLOYEEFILE.
		   READ EMPLOYEEFILE
			AT END SET ENDOFFILE TO TRUE
			END-READ.
		   DISPLAY WS-REPORT-TITLE.
		   DISPLAY WS-HEADING-LINE.	
		   DISPLAY WS-HEADING-LINE2.
		   
           PERFORM 0200-PROCESS-RECORDS UNTIL ENDOFFILE.
		 
		   PERFORM 0300-STOP-RUN.
	   
	   0200-PROCESS-RECORDS.
		   
           MOVE EMPLOYEESSN TO SSN-OUT.
		   INSPECT SSN-OUT REPLACING ALL ' ' BY '-'.
		   MOVE FIRSTNAME TO WS-DET-FNAME.
		   MOVE LASTNAME TO WS-DET-LNAME.
		   MOVE MIDDLEINIT TO WS-DET-MIDDLE.
           PERFORM 0250-VALIDATE-EMAIL.
		   DISPLAY WS-DETAIL-LINE.
		   READ EMPLOYEEFILE 
			 AT END SET ENDOFFILE TO TRUE
		   END-READ.
	   
	   0200-END.
       0250-VALIDATE-EMAIL.
          MOVE 0 TO WS-TALLY.
          INSPECT EMAIL TALLYING WS-TALLY FOR ALL '@'.
          IF WS-TALLY NOT = 1
             MOVE 'INVALID EMAIL' TO WS-DET-EMAIL 
          ELSE
             MOVE EMAIL TO WS-DET-EMAIL
          END-IF.
        0250-END.    
	   
	   0300-STOP-RUN.	
		
           CLOSE EMPLOYEEFILE.		
           STOP RUN.
           
          END PROGRAM INSPECTEMPLOYEES.
