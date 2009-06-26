// Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.


package detroit;

public class Pair
{
	public Object car;
	public Object cdr;

	public Pair(Object head, Object rest)
	{
		car = head;
		cdr = rest;
	}

	public Pair rest()
	{
		return (Pair)cdr;
	}

	public boolean equals(Object other)
	{
		return (other instanceof Pair) &&
			(car == null ? ((Pair)other).car == null : car.equals(((Pair)other).car)) &&
			(cdr == null ? ((Pair)other).cdr == null : cdr.equals(((Pair)other).cdr));
	}
}
