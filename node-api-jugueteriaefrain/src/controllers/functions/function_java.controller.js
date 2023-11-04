const { spawn } = require('child_process');

//Extrae el texto de un archivo pdf.
exports.extractTextFromPDF = (req, res) => {
    const child = spawn('java', ['-jar', 'C:\\Users\\david\\OneDrive\\Escritorio\\sistema_jugueteria_efrain_v3\\node-api-jugueteriaefrain\\services_java\\extract_text_from_pdf.jar', "-path", req.params.path]);
  
    child.stdout.on('data', (data) => {
      console.log(`stdout: ${data}`);
      res.status(200).send(data);
    });
  
    child.stderr.on('data', (data) => {
      console.error(`stderr: ${data}`);
      res.status(501).json({
        status: 501, 
        title: "Error 501",
        message: 'Error: No fue posible leer el archivo PDF brindado.',
        value: null,
        error: data.toString('utf8')
    });
    });
};