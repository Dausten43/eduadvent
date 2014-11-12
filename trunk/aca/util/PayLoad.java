package aca.util;

//General imports
import java.io.BufferedReader;
import java.io.InputStreamReader;
//Import SSC Client Libraries
import com.systemsunion.ssc.client.SecurityProvider;
import com.systemsunion.ssc.client.ComponentExecutor;

public class PayLoad {
	static String _SSCServerName;
	static int _SSCPortNo = 8080;
	
	public static void main(String[] args) {
		try {
			BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
			// Get SSC Server name
			System.out.print("SSC Server Name: ");
			System.out.flush();
			_SSCServerName = in.readLine();
			// Create instance of SecurityProvider so we can authenticate
			// the user and retrieve a voucher for SSC
			String _SSCVoucher = "";
			SecurityProvider sp = new SecurityProvider(_SSCServerName, false);
			_SSCVoucher = sp.Authenticate("PK1","abc");
			if(_SSCVoucher != "" && _SSCVoucher != null) {
				System.out.print("User Authenticated!\n\nVoucher retrieved: " +_SSCVoucher);
			}else{
				System.out.print("User not authenticated..."); 
				return;
			}	
			// Destroy Security Provider object
			sp = null;
			// Build input payload to pass to SunSystems - note that this is not
			// the most efficient way to build a string or XML
			String _InputPayload = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>" + 
					"<SSC>" + 
					" <User>" + 
					" <Name>PK1</Name>" + 
					" </User>" +
					" <SunSystemsContext>" +
					" <BusinessUnit>PK1</BusinessUnit>" +
					" </SunSystemsContext>" +
					" <Payload>" +
					" <Address>" +
					" <AddressCode>DEMO1</AddressCode>" +
					" <AddressLine1>My Street</AddressLine1>" +
					" <TownCity>My Town</TownCity>" +
					" <PostalCode>AB12 3CD</PostalCode>" +
					" <TelephoneNumber>01234567890</TelephoneNumber>" +
					" <LookupCode>DEMO1</LookupCode>" +
					" </Address>" +
					" </Payload>" +
					"</SSC>";
			// Create instance of ComponentExecutor so we can call SSC
			ComponentExecutor SSC = new ComponentExecutor(_SSCServerName, false);
			try{
				// Call SSC
				String result = SSC.Execute(_SSCVoucher, null,"Address","CreateOrAmend", null, _InputPayload);
				System.out.println("\n\nResult:\n");
				System.out.println(result);
			}catch(Exception ex){
				System.out.print("Call to SSC failed:\n\n");
				ex.printStackTrace();
			}
			// Destroy ComponentExecutor object
			SSC = null;
		}catch (Exception ex) {
			ex.printStackTrace();
		}
	}	
}
