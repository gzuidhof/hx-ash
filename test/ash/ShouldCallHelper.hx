package ash;

import haxe.PosInfos;


class ShouldCallHelper<Function>
{
    private var called:Bool;
    private var callback:Function;
    private var context:Dynamic;

    public var func(default, null):Function;

    public function new(callback:Function, context:Dynamic = null)
    {
        this.callback = callback;
        this.context = context;
        this.called = false;
        func = Reflect.makeVarArgs(_func);
    }

	/**
	 * Asserts that it was called, returns true if so.
	 * @param	info
	 * @return
	 */
    public function assertIsCalled(?info:PosInfos): Bool
    {
		if (!called)
		{
			throw "Awrf! ShouldCallHelper assert failed";
		}
		return called;
    }

    private function _func(args:Array<Dynamic>):Dynamic
    {
        var result = Reflect.callMethod(context, callback, args);
        called = true;
        return result;
    }
}
