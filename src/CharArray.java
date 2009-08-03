// Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

package detroit;

public class CharArray
{
	public char[] charArray;
	public int hash;

	public CharArray(char[] string)
	{
		charArray = string;
		hash = 0;
		for (int i=0; i<charArray.length; ++i)
		{
			hash = (hash << 5) - hash;
			hash += charArray[i];
		}
	}

	public int hashCode()
	{
		return hash;
	}

	public boolean equals(Object a)
	{
		return (a instanceof CharArray &&
				new String(charArray).equals(new String(((CharArray)a).charArray)));
	}
}
