// Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.


package detroit;

public class EqKey
{
	public Object value;

	public EqKey(Object v)
	{
		value = v;
	}

	public int hashCode()
	{
		return value.hashCode();
	}

	public boolean equals(Object other)
	{
		return value == other || (other instanceof EqKey && value == ((EqKey)other).value);
	}
}
