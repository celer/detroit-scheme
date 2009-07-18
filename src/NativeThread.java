// Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.


package detroit;

public class NativeThread extends Thread
{
	protected Interpreter interpreter;
	protected Object thunk;

	public NativeThread(Interpreter interpreter, Object thunk)
	{
		this.interpreter = interpreter;
		this.thunk = thunk;
	}

	public void run()
	{
		try {
			interpreter.apply(thunk, null);
		} catch (InterruptedException e) {
			Thread.currentThread().interrupt();
		} catch (Exception e) {
		}
	}
}
