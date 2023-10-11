package extract_text_from_pdf.controller;

import java.io.File;
import java.io.IOException;

import org.apache.pdfbox.Loader;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;
import org.json.JSONObject;

/**
 * Clase ExtractTextPDF: Es el controlador que realiza la extracción del texto del PDF que se recibe como argumento.
 * @author David Emanuel Latouquette.
 *
 */
public class ExtractTextPDF {
	
	private static final int FILE_ERROR = 1;	
	private static final int ARGS_ERROR = 2;	
	private static final int ARGS_EMPTY_ERROR = 3;
	private static final int ARGS_FILE_ERROR = 4;	
	private static final int ARGS_EXCEEDED_ERROR = 5;
	private static final int ARGS_NOT_PDF_ERROR = 6;

	private static final String FILE_ERROR_MESSAGE = "Error: No se pudo abrir el archivo. Verifique el directorio.";
	private static final String ARGS_ERROR_MESSAGE = "Error: No fue empleado el argumento -path.";
	private static final String ARGS_EMPTY_ERROR_MESSAGE = "Error: No fue empleado el argumento -path junto al archivo (-path archivo.pdf).";
	private static final String ARGS_FILE_ERROR_MESSAGE = "Error: No se brindó la ubicación del archivo.";
	private static final String ARGS_EXCEEDED_ERROR_MESSAGE = "Error: Se ha excedido la cantidad de argumentos al invocar el programa.";
	private static final String ARGS_NOT_PDF_ERROR_MESSAGE = "Error: El archivo dado no es un archivo PDF.";
	
	public static void main(String[] args) {
		JSONObject json;
		
		//Controla la cantidad de argumentos dados.
		int i=0;
		for (@SuppressWarnings("unused") String str: args) {
			i++;
		}
		
		//Si hay dos argumentos, puede ser que sean los dos requeridos.
		if (i==2) {
			//Si el primer argumento es el atributo -path
			if (args[0].equals("-path")) {
				//Comprueba si el archivo termina con .pdf
				if (args[1].endsWith(".pdf")) {
					json = extractTextFromPDF(args[1]);
				}
				else {
					json = getError(ARGS_NOT_PDF_ERROR);
				}
			}
			else {
				json = getError(ARGS_ERROR);
			}
		}
		else {
			if (i==0) {
				json = getError(ARGS_EMPTY_ERROR);
			}
			else {
				//Hay menos de dos argumentos
				json = (i<2) ? getError(ARGS_FILE_ERROR) : getError(ARGS_EXCEEDED_ERROR);
			}
		}


        // Imprima el texto en la consola
        System.out.println(json);
	}
	
	/**
	 * Realiza la extracción del texto para un archivo PDF dado.
	 * @param path Archivo a leer con su directorio.
	 * @return JSON con la información recuperada del archivo o JSON con el error ocurrido.
	 */
	private static JSONObject extractTextFromPDF(String path) {
		JSONObject toReturn;
		
		try {
			// Cargue el archivo PDF
	        File file = new File(path);
	        PDDocument document = Loader.loadPDF(file);

	        // Cree un objeto PDFTextStripper para extraer texto
	        PDFTextStripper pdfStripper = new PDFTextStripper();

	        // Obtenga el texto del documento
	        String text = pdfStripper.getText(document);

	        // Cierre el documento
	        document.close();
	        
	        //Construye el JSON
	        toReturn = getJSON(0, text); 
		}
		catch(IOException e) {
			toReturn = getError(FILE_ERROR);
		}
		
		return toReturn;
	}
	
	private static JSONObject getError(int error) {
		String message = "";
		
		switch(error) {
			case FILE_ERROR: {
				message = FILE_ERROR_MESSAGE;
				break;
			}
			case ARGS_ERROR: {
				message = ARGS_ERROR_MESSAGE;
				break;
			}
			case ARGS_FILE_ERROR: {
				message = ARGS_FILE_ERROR_MESSAGE;
				break;
			}
			case ARGS_EMPTY_ERROR: {
				message = ARGS_EMPTY_ERROR_MESSAGE;
				break;
			}
			case ARGS_EXCEEDED_ERROR: {
				message = ARGS_EXCEEDED_ERROR_MESSAGE;
				break;
			}
			case ARGS_NOT_PDF_ERROR: {
				message = ARGS_NOT_PDF_ERROR_MESSAGE;
				break;
			}
		}
		
		//Construye el JSON de error
		return getJSON(error, message);
	}
	
	/**
	 * Construye un objeto JSON a partir de un código de status y un mensaje.
	 * @param status Entero que indica el tipo de mensaje (0 si se obtuvo la información y distinto de 0 en caso contrario).
	 * @param message String con el texto.
	 * @return JSON.
	 */
	private static JSONObject getJSON(int status, String message) {
		JSONObject obj = new JSONObject();
	    obj.put("status", status);
	    obj.put("message", message);
		
		return obj;
	}
}
