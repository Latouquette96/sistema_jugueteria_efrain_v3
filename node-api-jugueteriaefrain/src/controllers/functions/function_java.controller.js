const { spawn } = require('child_process');

//Extrae el texto de un archivo pdf.
exports.extractTextFromPDF = (req, res) => {
    var dataReturn;
    const child = spawn('java', ['-jar', 'C:\\Users\\david\\OneDrive\\Escritorio\\sistema_jugueteria_efrain_v3\\node-api-jugueteriaefrain\\services_java\\extract_text_from_pdf.jar', "-path", req.body.path]);
  
    child.stdout.on('data', (data) => {
      dataReturn = data;
      console.log(`stdout: ${data}`);
    });
  
    child.stderr.on('data', (data) => {
      console.error(`stderr: ${data}`);
    });
  
    child.on('close', (code) => {
      res.send(dataReturn);
    });
};