package system_controller.gui;

import java.awt.EventQueue;

import javax.swing.JFrame;
import net.miginfocom.swing.MigLayout;
import javax.swing.JPanel;
import javax.swing.JLabel;
import java.awt.Font;
import javax.swing.JTextField;
import javax.swing.JButton;
import java.awt.Color;
import java.awt.SystemColor;
import javax.swing.border.EtchedBorder;
import javax.swing.SwingConstants;
import javax.swing.JTextPane;
import java.awt.event.ActionListener;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.awt.event.ActionEvent;

public class SystemController {

	private JFrame frmSystem;
	private JTextField txtStatus01, txtStatus02;
	private JButton btn01, btn02;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					SystemController window = new SystemController();
					window.frmSystem.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

	/**
	 * Create the application.
	 */
	public SystemController() {
		initialize();
	}

	/**
	 * Initialize the contents of the frame.
	 */
	private void initialize() {
		frmSystem = new JFrame();
		frmSystem.getContentPane().setBackground(SystemColor.activeCaptionBorder);
		frmSystem.setTitle("Lanzador: Sistema Juguetería Efraín v3 (2023.10.16)");
		frmSystem.setResizable(false);
		frmSystem.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frmSystem.setBounds(100, 100, 684, 354);
		frmSystem.getContentPane().setLayout(new MigLayout("", "[grow,fill]", "[30px:n:30px,grow,fill][100px:n:200px,grow,fill][100px:n:200px,grow,fill]"));
		
		JLabel lblTitle = new JLabel("Lanzador: Sistema Juguetería Efraín v3");
		lblTitle.setForeground(SystemColor.menu);
		lblTitle.setBackground(Color.DARK_GRAY);
		lblTitle.setHorizontalAlignment(SwingConstants.CENTER);
		lblTitle.setFont(new Font("Tahoma", Font.BOLD, 14));
		lblTitle.setOpaque(true);
		frmSystem.getContentPane().add(lblTitle, "cell 0 0");
		
		JPanel panel = new JPanel();
		panel.setBackground(SystemColor.menu);
		panel.setBorder(new EtchedBorder(EtchedBorder.LOWERED, null, null));
		frmSystem.getContentPane().add(panel, "cell 0 1,grow");
		panel.setLayout(new MigLayout("", "[grow,fill][]", "[30px:n:30px,grow,fill][grow,fill][30px:n:30px,grow,fill]"));
		
		JLabel lblTitle01 = new JLabel("Estado del servidor");
		lblTitle01.setFont(new Font("Tahoma", Font.BOLD, 14));
		panel.add(lblTitle01, "cell 0 0 2 1");
		
		JTextPane txtPaneInfo01 = new JTextPane();
		txtPaneInfo01.setFont(new Font("Tahoma", Font.PLAIN, 14));
		txtPaneInfo01.setBackground(SystemColor.menu);
		txtPaneInfo01.setEditable(false);
		txtPaneInfo01.setText("El servidor debe ser iniciado para que el sistema pueda acceder a la información importante, así como también poder realizar la mayoría de las funciones del sistema.");
		panel.add(txtPaneInfo01, "cell 0 1 2 1,grow");
		
		txtStatus01 = new JTextField();
		panel.add(txtStatus01, "cell 0 2,growx");
		txtStatus01.setColumns(10);
		
		btn01 = new JButton("Iniciar");
		btn01.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				ProcessBuilder pb = new ProcessBuilder("cmd.exe", "/c", "start", "/b", "node.exe", "../../node-api-jugueteriaefrain/index.js", "|", "notepad");
		        pb.redirectErrorStream(true);
		        Process process;
				try {
					process = pb.start();
					BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
			        String line;
			        while ((line = reader.readLine()) != null) {
			            System.out.println(line);
			        }
			        
			        process.destroy();
				} 
				catch (IOException e1) {
					e1.printStackTrace();
				}
		        

			}
		});
		btn01.setFont(new Font("Tahoma", Font.PLAIN, 14));
		panel.add(btn01, "cell 1 2");
		
		JPanel panel_1 = new JPanel();
		panel_1.setBackground(SystemColor.menu);
		panel_1.setBorder(new EtchedBorder(EtchedBorder.LOWERED, null, null));
		frmSystem.getContentPane().add(panel_1, "cell 0 2,grow");
		panel_1.setLayout(new MigLayout("", "[grow][]", "[30px:n:30px,grow,fill][grow][30px:n:30px,grow,fill]"));
		
		JLabel lblTitle02 = new JLabel("Sistema Juguetería Efraín v3");
		lblTitle02.setFont(new Font("Tahoma", Font.BOLD, 14));
		panel_1.add(lblTitle02, "cell 0 0");
		
		JTextPane txtPaneInfo02 = new JTextPane();
		txtPaneInfo02.setText("Presione \"Iniciar\" para ejecutar el programa principal \"Sistema: Juguetería Efraín v3\". Dicho programa es el que permite gestionar el stock y precios de los productos, la información de distribuidoras, entre otras cosas.");
		txtPaneInfo02.setFont(new Font("Tahoma", Font.PLAIN, 14));
		txtPaneInfo02.setEditable(false);
		txtPaneInfo02.setBackground(SystemColor.menu);
		panel_1.add(txtPaneInfo02, "cell 0 1 2 1,grow");
		
		txtStatus02 = new JTextField();
		txtStatus02.setColumns(10);
		panel_1.add(txtStatus02, "cell 0 2,growx");
		
		btn02 = new JButton("Iniciar");
		btn02.setFont(new Font("Tahoma", Font.PLAIN, 14));
		panel_1.add(btn02, "cell 1 2");
	}

}
