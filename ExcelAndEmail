#Opens csv to be copied and copies data
$Excel = New-Object -ComObject excel.application 
    $Excel.visible = $false 
    $Excel.DisplayAlerts = $false 
    $Workbook = $Excel.Workbooks.open("C:\test.csv") #change to correct file
    $Worksheet = $Workbook.WorkSheets.item(1) 
    $worksheet.activate()  
    $range = $WorkSheet.Range("A1:Z1").EntireColumn #change range if needed
    $range.Copy() 
$Excel.Quit()


#Opens xlsm and pastes data
$Excel2 = New-Object -ComObject excel.application 
    $Excel2.visible = $false 
    $Excel2.DisplayAlerts = $false 
    $Workbook2 = $Excel2.Workbooks.open("C:\test.xlsm") #change to correct file
    $Worksheet2 = $Workbook2.Worksheets.item(1) 
    $Range2 = $Worksheet2.Range("A1") 
    $Worksheet2.Paste()  
    $workbook2.Save()  
$Excel2.Quit() 


#Opens the xlsm and runs the macro
$excel3 = new-object -comobject excel.application
    $workbook = $excel3.workbooks.open("C:\test.xlsm")  #change to correct file
    $worksheet = $workbook.worksheets.item(1)
    $excel3.Run("test.xlsm!Macro")  #change to correct file and macro
    $workbook.save()
    $workbook.close()
$excel3.quit()


#Saves excel as PDF
$xlFixedFormat = "Microsoft.Office.Interop.Excel.xlFixedFormatType" -as [type]  
    $objExcel = New-Object -ComObject excel.application 
    $objExcel.visible = $false 
    $workbook = $objExcel.workbooks.open("C:\test.xlsm")  #change to correct file
    $worksheet = $workbook.worksheets.item(1) 
    Write-Host "saving pdf" 
    $workbook.ExportAsFixedFormat($xlFixedFormat::xlTypePDF, "c:\test.pdf")  #change to preffered file
    $objExcel.Workbooks.close() 
$objExcel.Quit() 


#Pulls column of emails from multiple sheets
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


#Sends email to each of the emails 
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
