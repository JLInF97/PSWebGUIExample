
<#PSScriptInfo

.VERSION 1.0.0

.GUID f41eadbf-9c2d-4efb-a252-24a7f41cc7bf

.AUTHOR JLInF97

.COMPANYNAME 

.COPYRIGHT 

.TAGS PSWebGUI

.LICENSEURI 

.PROJECTURI https://github.com/JLInF97/PSWebGUIExample

.ICONURI https://github.com/JLInF97/PSWebGUIExample/blob/main/LICENSE

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS 

.EXTERNALSCRIPTDEPENDENCIES 

.RELEASENOTES


#> 

#Requires -RunAsAdministrator
#Requires -Module PSWebGUI

<# 

.DESCRIPTION 
 Sample script demonstrating the use of the PSWebGUI module 

#> 

Param()


$routes=@{

    "/showProcesses" = {
        Set-Title -Title "Processes"
        "<div class='container-fluid'>
            <a href='/'>Main Menu</a>
            <form action='/filterProcesses'>Filter:<input Name='Name'></input></form>"
            Get-Process | Select-Object cpu,name | Format-Html -Striped -Darkheader -Hover
        "</div>"
    }

    "/filterProcesses" = {
        "<a href='/'>Main Menu</a>
        <form action='/filterProcesses'>Filter:<input Name='Name'></input></form>"
        Get-Process $_GET["Name"] | Select-Object cpu, name | Format-Html
     }

    "/showServices" = {
        "<a href='/'>Main Menu</a>
        <form action='/filterServices' method='post'>Filter:<input Name='Name'></input></form>"
        Get-Service | Select-Object Name,Status | Format-Html -Cards 6
    }

    "/filterServices" = {
        "<a href='/'>Main Menu</a>
        <form action='/filterServices' method='post'>Filter:<input Name='Name'></input></form>"
        Get-Service $_POST["Name"] | Select-Object Status,Name,DisplayName | Format-Html    
    }

    "/showDate" = {"<a href='/'>Main Menu</a><br/>$(Get-Date | Format-Html -Raw)"}


    "/loginform"={
        Write-CredentialForm -FormTitle "Login" -Action "/login"
    }

    "/login"={
        $creds=Get-CredentialForm

        "<a href='/'>Main Menu</a>"
        $creds | Format-Html
    }


    "/" = {
        $title="Index"
        "<div class='container-fluid'>
            <h1>My Simple Task Manager</h1>
            <a href='showProcesses'><h2>Show Running Processes</h2></a>
            <a href='/showServices'><h2>Show Running Services</h2></a>
            <a href='/showDate'><h2>Show current datetime</h2></a>
            <a href='/loginform'><h2>Login</h2></a>
        </div>"
    }


}


Show-PSWebGUI -InputObject $routes -Icon "/panel.png" -Root "$PSScriptRoot\public"
