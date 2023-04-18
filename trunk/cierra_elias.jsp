<%
	}catch (SQLException se){                
	    System.out.println("Error: "+se);
	}catch (Exception e){                
	    System.out.println("Error: "+ e.getMessage());
	    e.printStackTrace();
	}finally{
		if (conElias!=null) conElias.close(); 
		conElias 	= null;
		if (conSunPlus!=null) conSunPlus.close();
		conSunPlus	= null;
	}
%>
