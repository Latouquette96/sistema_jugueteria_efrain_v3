const { spawn } = require('child_process');

//Extrae el texto de un archivo pdf.
exports.extractTextFromPDF = (req, res) => {
    var dataReturn;
    var dataError;
    var status;

    const child = spawn('java', ['-jar', 'C:\\Users\\david\\OneDrive\\Escritorio\\sistema_jugueteria_efrain_v3\\node-api-jugueteriaefrain\\services_java\\extract_text_from_pdf.jar', "-path", req.body.path]);
  
    child.stdout.on('data', (data) => {
      status = 200;
      dataReturn = data;
      console.log(`stdout: ${data}`);
    });
  
    child.stderr.on('data', (data) => {
      status = 501;
      dataError = data;
      console.error(`stderr: ${data}`);
    });
  
    child.on('close', (code) => {
      res.send(dataReturn);
      res.json({
        status: status, 
        title: (status===501) ? "Error 501" : "Texto recuperado",
        message: (status===501) ? 'Error: No fue posible leer el archivo PDF brindado.': 'El archivo PDF fue leído con éxito.',
        value: (status===501) ? null : dataReturn,
        error: (status===501) ? dataError : null
    });
    });
};