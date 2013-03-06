PowerShell
==========

PowerShell




#Pulls column of emails from multiple sheets NEW SECTION

$ExcelWB = new-object -comobject excel.application
    $ExcelWB.Visible = $false  
    $Workbook = $ExcelWB.Workbooks.Open("C:\test.xlsx") 

    $Sheet = 1
    $ColValues = @()

    #loop through workbook
    foreach  ($Worksheet in $Workbook.worksheets) {

        $Worksheet = $Workbook.Worksheets.Item($Sheet) 
        $startRow = 3

        #pull data from column (2 in this example) - while not empty!!!
        Do { 
            $ColValues += $Worksheet.Cells.Item($startRow, 2).Value()
            $startRow++
        }
        While ($Worksheet.Cells.Item($startRow,2).Value() -ne $null) 
   
        #used to test variable
        Write-Host $ColValues.count
        Write-Host $ColValues.Item(1)

        $Sheet++

    }

$ExcelWB.Quit() 




#Sends email to each of the emails NEW SECTION
Write-Host "Sending Email"


$counter = 0 

$ColValues | foreach{

     #test what email is being sent
     Write-Host $ColValues.Item($counter)

     if($ColValues.Item($counter) -ne "none"){

        #SMTP server name
        $smtpServer = "UMCDFEX.umcdf.local" #Change this if different server

        #Creating a Mail object
        $msg = new-object Net.Mail.MailMessage

        #Creating SMTP server object
        $smtp = new-object Net.Mail.SmtpClient($smtpServer)

        #Adding attachement
        $file = "C:\test.xlsm"  #change to correct file
        $att = new-object Net.Mail.Attachment($file)
        $file = "C:\test.xlsx"  #change to correct file
        $att2 = new-object Net.Mail.Attachment($file)

        #Email structure CHANGE all that is needed
        $msg.From = "robert.theriault@urs.com"
        $msg.ReplyTo = "robert.theriault@urs.com"
        $msg.To.Add($ColValues.Item($counter))
        $msg.subject = "Weekly Job Postings - TEST"
        $msg.body = "This email brought to you by powershell... and Robert."
        $msg.Attachments.Add($att)
        $msg.Attachments.Add($att2)

 

        #Sending email 
        $smtp.Send($msg)
    }
        
    $counter++
}
