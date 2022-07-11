FROM mcr.microsoft.com/windows/servercore:ltsc2019
ENV wacuser="_" \
    wacpassword="_" \
    admin_password_path="C:\ProgramData\Docker\secrets\admin-password"
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]
COPY *.mst /
COPY *.ps1 /
WORKDIR /
RUN powershell.exe -command \
    Invoke-WebRequest -Uri 'https://go.microsoft.com/fwlink/p/?linkid=2194936' -OutFile 'c:\wac.msi' ; \
    Start-Process c:\wac.msi -ArgumentList '/qn /L*v c:\log.txt SME_PORT=443 SSL_CERTIFICATE_OPTION=generate TRANSFORMS=wac-install.mst' -Wait ; \
    Remove-Item -Force 'c:\wac.msi'
RUN .\activetls.ps1
HEALTHCHECK --interval=5s \
 CMD powershell -command try { $response = iwr https://localhost:443 -UseBasicParsing -UseDefaultCredentials; \
     if ($response.StatusCode -eq 200) { return 0} else {return 1}; \
    } catch { return 1 }
CMD .\start -wac_user $env:wacuser -wac_password $env:wacpassword -Verbose
EXPOSE 443
