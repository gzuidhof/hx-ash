package ash.signals;

import org.hamcrest.MatchersBase;

import ash.signals.Signal0;

class SignalTest extends MatchersBaseTestCase
{
    private var signal:Signal0;

    @Before
    override public function setup():Void
    {
        signal = new Signal0();
    }

    @After
    override public function tearDown():Void
    {
        signal = null;
    }

    private function dispatchSignal():Void
    {
        signal.dispatch();
    }

    private function shouldCall(f = null)
    {
        if (f == null)
            f = newEmptyHandler();
        return new ShouldCallHelper(f, this);
    }

    private static function newEmptyHandler():Dynamic
    {
        // due to strange bug/feature in neko,
        // function comparison will return true
        // for different anonymous function if they
        // dont hold any outer context
        var ctx = null;
        return function():Void
        {
            ctx;
        };
    }

    private function failIfCalled():Void
    {
		
        throw ('This function should not have been called.');
		assertTrue(false);
    }

    private function methodFailIfCalled():Void
    {
		throw ('This function should not have been called.');
		assertTrue(false);
    }

    @Test
    public function testnewSignalHasNullHead():Void
    {
        assertThat(signal.head, nullValue());
    }

    @Test
    public function testnewSignalHasListenersCountZero():Void
    {
        assertThat(signal.numListeners, equalTo(0));
    }

    @Test
    public function testaddListenerThenDispatchShouldCallIt():Void
    {
        var h = shouldCall();
        signal.add(h.func);
        dispatchSignal();
        assertTrue(h.assertIsCalled());
    }

    @Test
    public function testaddListenerThenListenersCountIsOne():Void
    {
        signal.add(newEmptyHandler());
        assertThat(signal.numListeners, equalTo(1));
    }

    @Test
    public function testaddListenerThenRemoveThenDispatchShouldNotCallListener():Void
    {
        signal.add(failIfCalled);
        signal.remove(failIfCalled);
        dispatchSignal();
		
		//Necessary because assertion is necessary. Actual assert is in in failIfcalled.
		assertTrue(true);
    }

    @Test
    public function testaddListenerThenRemoveThenListenersCountIsZero():Void
    {
        signal.add(failIfCalled);
        signal.remove(failIfCalled);
        assertThat(signal.numListeners, equalTo(0));
    }

    @Test
    public function testaddMethodListenerThenRemoveThenDispatchShouldNotCallListener():Void
    {
        signal.add(methodFailIfCalled);
        signal.remove(methodFailIfCalled);
        dispatchSignal();
		
		//Necessary because assertion is necessary. Actual assert is in in failIfcalled.
		assertTrue(true);
    }

    @Test
    public function testaddMethodListenerThenRemoveThenListenersCountIsZero():Void
    {
        signal.add(methodFailIfCalled);
        signal.remove(methodFailIfCalled);
        assertThat(signal.numListeners, equalTo(0));
    }

    @Test
    public function testremoveFunctionNotInListenersShouldNotThrowError():Void
    {
        signal.remove(newEmptyHandler());
        dispatchSignal();
		
		//Necessary because assertion is necessary. Actual assert is in in failIfcalled.
		assertTrue(true);
    }

    @Test
    public function testaddListenerThenRemoveFunctionNotInListenersShouldStillCallListener():Void
    {
        var h = shouldCall();
        signal.add(h.func);
        signal.remove(function() {});
        dispatchSignal();
        assertTrue(h.assertIsCalled());
    }

    @Test
    public function testadd2ListenersThenDispatchShouldCallBoth():Void
    {
        var h1 = shouldCall();
        var h2 = shouldCall();
        signal.add(h1.func);
        signal.add(h2.func);
        dispatchSignal();
        assertTrue(h1.assertIsCalled());
        assertTrue(h2.assertIsCalled());
    }

    @Test
    public function testadd2ListenersThenListenersCountIsTwo():Void
    {
        signal.add(newEmptyHandler());
        signal.add(newEmptyHandler());
        assertThat(signal.numListeners, equalTo(2));
    }

    @Test
    public function testadd2ListenersRemove1stThenDispatchShouldCall2ndNot1stListener():Void
    {
        var h = shouldCall();
        signal.add(failIfCalled);
        signal.add(h.func);
        signal.remove(failIfCalled);
        dispatchSignal();
        assertTrue(h.assertIsCalled());
    }

    @Test
    public function testadd2ListenersRemove2ndThenDispatchShouldCall1stNot2ndListener():Void
    {
        var h = shouldCall();
        signal.add(h.func);
        signal.add(failIfCalled);
        signal.remove(failIfCalled);
        dispatchSignal();
        assertTrue(h.assertIsCalled());
    }

    @Test
    public function testadd2ListenersThenRemove1ThenListenersCountIsOne():Void
    {
        signal.add(newEmptyHandler());
        signal.add(failIfCalled);
        signal.remove(failIfCalled);
        assertThat(signal.numListeners, equalTo(1));
    }

    @Test
    public function testaddSameListenerTwiceShouldOnlyAddItOnce():Void
    {
        var count:Int = 0;
        var func = function():Void
        {
            ++count;
        };
        signal.add(func);
        signal.add(func);
        dispatchSignal();
        assertThat(count, equalTo(1));
    }

    @Test
    public function testaddTheSameListenerTwiceShouldNotThrowError():Void
    {
        var listener = newEmptyHandler();
        signal.add(listener);
        signal.add(listener);
		//Necessary because assertion is necessary. Actual assert is not throwing an error.
		assertTrue(true);
    }

    @Test
    public function testaddSameListenerTwiceThenListenersCountIsOne():Void
    {
        signal.add(failIfCalled);
        signal.add(failIfCalled);
        assertThat(signal.numListeners, equalTo(1));
    }

    @Test
    public function testdispatch2Listeners1stListenerRemovesItselfThen2ndListenerIsStillCalled():Void
    {
        var h = shouldCall();
        signal.add(selfRemover);
        signal.add(h.func);
        dispatchSignal();
        assertTrue(h.assertIsCalled());
    }

    private function selfRemover():Void
    {
        signal.remove(selfRemover);
    }

    @Test
    public function testdispatch2Listeners2ndListenerRemovesItselfThen1stListenerIsStillCalled():Void
    {
        var h = shouldCall();
        signal.add(h.func);
        signal.add(selfRemover);
        dispatchSignal();
        assertTrue(h.assertIsCalled());
    }

    @Test
    public function testaddingAListenerDuringDispatchShouldNotCallIt():Void
    {
        var h = shouldCall(addListenerDuringDispatch);
        signal.add(h.func);
        dispatchSignal();
        assertTrue(h.assertIsCalled());
    }

    private function addListenerDuringDispatch():Void
    {
        signal.add(failIfCalled);
    }

    @Test
    public function testaddingAListenerDuringDispatchIncrementsListenersCount():Void
    {
        signal.add(addListenerDuringDispatchToTestCount);
        dispatchSignal();
        assertThat(signal.numListeners, equalTo(2));
    }

    private function addListenerDuringDispatchToTestCount():Void
    {
        assertThat(signal.numListeners, equalTo(1));
        signal.add(newEmptyHandler());
        assertThat(signal.numListeners, equalTo(2));
    }

    @Test
    public function testdispatch2Listeners2ndListenerRemoves1stThen1stListenerIsNotCalled():Void
    {
        signal.add(removeFailListener);
        signal.add(failIfCalled);
        dispatchSignal();
		
		//Necessary because assertion is necessary. Actual assert is in in failIfcalled.
		assertTrue(true);
    }

    private function removeFailListener():Void
    {
        signal.remove(failIfCalled);
    }

    @Test
    public function testadd2ListenersThenRemoveAllShouldLeaveNoListeners():Void
    {
        signal.add(newEmptyHandler());
        signal.add(newEmptyHandler());
        signal.removeAll();
        assertThat(signal.head, nullValue());
    }

    @Test
    public function testaddListenerThenRemoveAllThenAddAgainShouldAddListener():Void
    {
        var handler = newEmptyHandler();
        signal.add(handler);
        signal.removeAll();
        signal.add(handler);
        assertThat(signal.numListeners, equalTo(1));
    }

    @Test
    public function testadd2ListenersThenRemoveAllThenListenerCountIsZero():Void
    {
        signal.add(newEmptyHandler());
        signal.add(newEmptyHandler());
        signal.removeAll();
        assertThat(signal.numListeners, equalTo(0));
    }

    @Test
    public function testremoveAllDuringDispatchShouldStopAll():Void
    {
        signal.add(removeAllListeners);
        signal.add(failIfCalled);
        signal.add(newEmptyHandler());
        dispatchSignal();
		
		//Necessary because assertion is necessary. Actual assert is in in failIfcalled.
		assertTrue(true);
    }

    private function removeAllListeners():Void
    {
        signal.removeAll();
    }

    @Test
    public function testaddOnceListenerThenDispatchShouldCallIt():Void
    {
        var h = shouldCall();
        signal.addOnce(h.func);
        dispatchSignal();
        assertTrue(h.assertIsCalled());
    }

    @Test
    public function testaddOnceListenerShouldBeRemovedAfterDispatch():Void
    {
        signal.addOnce(newEmptyHandler());
        dispatchSignal();
        assertThat(signal.head, nullValue());
    }
}

