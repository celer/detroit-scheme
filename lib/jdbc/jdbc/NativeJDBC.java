// Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

package nativejdbc;

// native jdbc interface 

import detroit.*;
import java.util.Hashtable;
import java.sql.*;

public class NativeJDBC  {
	protected Connection con = null;
	private static Boolean TRUE = Boolean.TRUE;
	private static Boolean FALSE = Boolean.FALSE;

	public NativeJDBC(String url, String driver) throws SQLException, ClassNotFoundException
	{
		try {
			Class.forName(driver);
			this.con = DriverManager.getConnection(url);
		}
		catch(Exception e)
		{
			if(con != null)
				con.close();
		}
	}
	public Pair execute(String query) throws SQLException
	{
		Statement stmt = null;
		ResultSet rs = null;
		Pair jdbcResultSet = new Pair(null,null);

		try 
		{
			stmt = con.createStatement();
			if(stmt.execute(query))
			{
				rs = stmt.getResultSet();
				ResultSetMetaData rsmd = rs.getMetaData();

				int numberOfColumns = rsmd.getColumnCount();
				while(rs.next()) {
					Hashtable htRow = new Hashtable();
					for (int i=1; i <= numberOfColumns; i++)
					{
						String field = rsmd.getColumnName(i);
						Object value = rs.getObject(i);
						if (value == null)
						{
							value = Interpreter.cons(FALSE,FALSE);
						} else if (value.getClass() == String.class)
						{
							value=((String)value).toCharArray();
						}
						CharArray key = new CharArray(field.toCharArray());
						htRow.put(key,value);
					}
					Interpreter.appendToList(jdbcResultSet, htRow); 
				}
			}
		} 
		catch(SQLException e)
		{
			e.printStackTrace();
		}
		finally
		{
			if(stmt != null)
				stmt.close();
			if(rs != null)
				rs.close();
		}
		return Interpreter.getList(jdbcResultSet);
	}

}
