// Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

package detroit;
import java.util.*;

public final class Environment
{
	public Pair exports = null;
	public Hashtable symbolTable = new Hashtable();
	public Vector slots = new Vector();
	public Hashtable macros = new Hashtable();
}
