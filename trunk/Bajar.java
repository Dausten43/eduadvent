import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * 
 */

/**
 * @author ifo
 *
 */
public class Bajar extends HttpServlet{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			HttpSession session = request.getSession();
			String nombre=request.getParameter("nombre");
			byte[] archivo = (byte[])session.getAttribute("archivo");
			response.setHeader("Pragma", "no-cache");
			response.setHeader("Cache-Control", "no-cache");
			response.setHeader("Cache-Control", "no-store");
			response.setHeader("Cache-Control", "max-age=0");
			response.setHeader("Cache-Control", "must-revalidate");
			response.setDateHeader("Expires", 0); 
			response.setContentType("application/octet-stream");
			response.setHeader("Content-Disposition","attachment; filename=\""+ nombre + "\"");
			response.getOutputStream().write(archivo);
		} catch ( Exception e ) {
			e.printStackTrace();
		}
	} 
}
