# Cargar el módulo de Windows Forms
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Crear la ventana principal
$form = New-Object System.Windows.Forms.Form
$form.Text = "HomeMadeCleaner"
$form.Size = New-Object System.Drawing.Size(600, 400)
$form.StartPosition = "CenterScreen"

# Crear un label para el título
$label = New-Object System.Windows.Forms.Label
$label.Text = "Bienvenido a HomeMadeCleaner"
$label.Font = New-Object System.Drawing.Font("Arial", 14, [System.Drawing.FontStyle]::Bold)
$label.AutoSize = $true
$label.Location = New-Object System.Drawing.Point(20, 20)
$form.Controls.Add($label)

# Crear un label para el resumen
$summaryLabel = New-Object System.Windows.Forms.Label
$summaryLabel.Text = "Resumen de lo que se va a borrar:"
$summaryLabel.Font = New-Object System.Drawing.Font("Arial", 12)
$summaryLabel.AutoSize = $true
$summaryLabel.Location = New-Object System.Drawing.Point(20, 70)
$form.Controls.Add($summaryLabel)

# Crear un cuadro de texto para mostrar el resumen
$summaryTextBox = New-Object System.Windows.Forms.TextBox
$summaryTextBox.Multiline = $true
$summaryTextBox.ReadOnly = $true
$summaryTextBox.ScrollBars = "Vertical"
$summaryTextBox.Size = New-Object System.Drawing.Size(540, 180)
$summaryTextBox.Location = New-Object System.Drawing.Point(20, 100)
$form.Controls.Add($summaryTextBox)

# Crear un botón para iniciar la limpieza
$cleanButton = New-Object System.Windows.Forms.Button
$cleanButton.Text = "Iniciar Limpieza"
$cleanButton.Font = New-Object System.Drawing.Font("Arial", 12)
$cleanButton.AutoSize = $true
$cleanButton.Location = New-Object System.Drawing.Point(20, 300)
$cleanButton.Add_Click({
    $form.Close()
    Start-Cleaning
})
$form.Controls.Add($cleanButton)

# Crear un botón para cancelar
$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Text = "Cancelar"
$cancelButton.Font = New-Object System.Drawing.Font("Arial", 12)
$cancelButton.AutoSize = $true
$cancelButton.Location = New-Object System.Drawing.Point(150, 300)
$cancelButton.Add_Click({
    $form.Close()
})
$form.Controls.Add($cancelButton)

# Crear un botón para mostrar créditos
$creditsButton = New-Object System.Windows.Forms.Button
$creditsButton.Text = "Créditos"
$creditsButton.Font = New-Object System.Drawing.Font("Arial", 12)
$creditsButton.AutoSize = $true
$creditsButton.Location = New-Object System.Drawing.Point(280, 300)
$creditsButton.Add_Click({
    Show-Credits
})
$form.Controls.Add($creditsButton)

# Función para generar el resumen
function Generate-Summary {
    $summary = "Resumen de lo que se va a borrar:`n----------------------------------`n"
    $summary += "`nArchivos y carpetas a eliminar:`n"
    foreach ($folder in $foldersToClear) {
        if (Test-Path $folder) {
            $items = Get-ChildItem -Path $folder -Recurse -Force -ErrorAction SilentlyContinue
            $itemCount = $items.Count
            if ($itemCount -gt 0) {
                $folderSize = Get-FolderSize -FolderPath $folder
                $folderSizeGB = [math]::Round($folderSize / 1GB, 2)
                $summary += "- $folder ($itemCount archivos/carpetas, $folderSizeGB GB)`n"
            }
        }
    }

    $summary += "`nClaves del registro a eliminar:`n"
    foreach ($registryKey in $registryKeysToClear) {
        if (Test-Path $registryKey) {
            $subKeys = (Get-Item $registryKey).GetSubKeyNames()
            $keyCount = $subKeys.Count
            if ($keyCount -gt 0) {
                $summary += "- $registryKey ($keyCount claves)`n"
            }
        }
    }

    $summaryTextBox.Text = $summary
}

# Función para iniciar la limpieza
function Start-Cleaning {
    # Aquí va el código de limpieza que ya tienes en tu script
    # Por ejemplo:
    foreach ($folder in $foldersToClear) {
        Clear-Folder -FolderPath $folder
    }
    foreach ($registryKey in $registryKeysToClear) {
        Clear-Registry -RegistryPath $registryKey
    }
    Write-Host "Limpieza completada." -ForegroundColor Green
}

# Función para mostrar la ventana de créditos
function Show-Credits {
    $creditsForm = New-Object System.Windows.Forms.Form
    $creditsForm.Text = "Créditos"
    $creditsForm.Size = New-Object System.Drawing.Size(400, 300)
    $creditsForm.StartPosition = "CenterScreen"

    # Crear un PictureBox para mostrar la imagen
    $pictureBox = New-Object System.Windows.Forms.PictureBox
    $pictureBox.Image = [System.Drawing.Image]::FromFile("$PWD\about.jpg")
    $pictureBox.Size = New-Object System.Drawing.Size(161, 200)
    $pictureBox.Location = New-Object System.Drawing.Point(120, 50)
    $creditsForm.Controls.Add($pictureBox)

    # Crear un label para los créditos
    $creditsLabel = New-Object System.Windows.Forms.Label
    $creditsLabel.Text = "Autor: Martin Alejandro Oviedo`nDesarrollador: DeePSurfer"
    $creditsLabel.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Bold)
    $creditsLabel.AutoSize = $true
    $creditsLabel.Location = New-Object System.Drawing.Point(20, 260)
    $creditsForm.Controls.Add($creditsLabel)

    # Crear un botón para cerrar la ventana de créditos
    $closeButton = New-Object System.Windows.Forms.Button
    $closeButton.Text = "Cerrar"
    $closeButton.Font = New-Object System.Drawing.Font("Arial", 12)
    $closeButton.AutoSize = $true
    $closeButton.Location = New-Object System.Drawing.Point(150, 280)
    $closeButton.Add_Click({
        $creditsForm.Close()
    })
    $creditsForm.Controls.Add($closeButton)

    $creditsForm.ShowDialog()
}

# Mostrar la ventana y generar el resumen
Generate-Summary
$form.ShowDialog()
