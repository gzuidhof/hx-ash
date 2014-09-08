package ash.core;

import org.hamcrest.MatchersBase;

import ash.core.Engine;
import ash.core.System;
import ash.Mocks;

class SystemTest extends MatchersBaseTestCase
{
    public var callBack:Dynamic;

    private var engine:Engine;

    private var system1:MockSystem;
    private var system2:MockSystem;

    @Before
    override public function setup():Void
    {
        engine = new Engine();
    }

    @After
    override public function tearDown():Void
    {
        engine = null;
        callBack = null;
    }

    @Test
    public function testsystemsGetterReturnsAllTheSystems():Void
    {
        var system1:System = Type.createInstance(System, []);
        engine.addSystem(system1, 1);
        var system2:System = Type.createInstance(System, []);
        engine.addSystem(system2, 1);
        assertThat(engine.systems, hasItems([system1, system2]));
    }

    private function shouldCall<T>(f:T)
    {
        return new ShouldCallHelper(f, this);
    }

    @Test
    public function testaddSystemCallsAddToEngine():Void
    {
        var h = shouldCall(addedCallbackMethod);
        var system:System = new MockSystem( this );
        callBack = h.func;
        engine.addSystem(system, 0);
        assertTrue(h.assertIsCalled());
    }

    @Test
    public function testremoveSystemCallsRemovedFromEngine():Void
    {
        var h = shouldCall(removedCallbackMethod);
        var system:System = new MockSystem( this );
        engine.addSystem(system, 0);
        callBack = h.func;
        engine.removeSystem(system);
        assertTrue(h.assertIsCalled());
    }

    @Test
    public function testengineCallsUpdateOnSystems():Void
    {
        var h = shouldCall(updateCallbackMethod);
        var system:System = new MockSystem( this );
        engine.addSystem(system, 0);
        callBack = h.func;
        engine.update(0.1);
        assertTrue(h.assertIsCalled());
    }

    @Test
    public function testdefaultPriorityIsZero():Void
    {
        var system:System = new MockSystem( this );
        assertThat(system.priority, equalTo(0));
    }

    @Test
    public function testcanSetPriorityWhenAddingSystem():Void
    {
        var system:System = new MockSystem( this );
        engine.addSystem(system, 10);
        assertThat(system.priority, equalTo(10));
    }

    @Test
    public function testsystemsUpdatedInPriorityOrderIfSameAsAddOrder():Void
    {
        system1 = new MockSystem( this );
        engine.addSystem(system1, 10);
        system2 = new MockSystem( this );
        engine.addSystem(system2, 20);
        //        asyncCallback = async.createHandler(this, updateCallbackMethod1);
        callBack = updateCallbackMethod1;
        engine.update(0.1);
    }

    @Test
    public function testsystemsUpdatedInPriorityOrderIfReverseOfAddOrder():Void
    {
        system2 = new MockSystem( this );
        engine.addSystem(system2, 20);
        system1 = new MockSystem( this );
        engine.addSystem(system1, 10);
        //        asyncCallback = async.add(updateCallbackMethod1);
        callBack = updateCallbackMethod1;
        engine.update(0.1);
    }

    @Test
    public function testsystemsUpdatedInPriorityOrderIfPrioritiesAreNegative():Void
    {
        system2 = new MockSystem( this );
        engine.addSystem(system2, 10);
        system1 = new MockSystem( this );
        engine.addSystem(system1, -20);
        //        asyncCallback = async.add(updateCallbackMethod1, 10);
        callBack = updateCallbackMethod1;
        engine.update(0.1);
    }

    @Test
    public function testupdatingIsFalseBeforeUpdate():Void
    {
        assertThat(engine.updating, is(false));
    }

    @Test
    public function testupdatingIsTrueDuringUpdate():Void
    {
        var system:System = new MockSystem( this );
        engine.addSystem(system, 0);
        callBack = assertsUpdatingIsTrue;
        engine.update(0.1);
    }

    @Test
    public function testupdatingIsFalseAfterUpdate():Void
    {
        engine.update(0.1);
        assertThat(engine.updating, is(false));
    }

    @Test
    public function testcompleteSignalIsDispatchedAfterUpdate():Void
    {
        var h = shouldCall(function() {});
        var system:System = new MockSystem( this );
        engine.addSystem(system, 0);
        callBack = function(s, a, t) { engine.updateComplete.add(h.func); };
        engine.update(0.1);
        assertTrue(h.assertIsCalled());
    }

    @Test
    public function testgetSystemReturnsTheSystem():Void
    {
        var system1:System = new MockSystem( this );
        engine.addSystem(system1, 0);
        engine.addSystem(new EmptySystem(), 0);
        assertThat(engine.getSystem(MockSystem), sameInstance(system1));
    }

    @Test
    public function testgetSystemReturnsNullIfNoSuchSystem():Void
    {
        engine.addSystem(new EmptySystem(), 0);
        assertThat(engine.getSystem(MockSystem), nullValue());
    }

    @Test
    public function testremoveAllSystemsDoesWhatItSays():Void
    {
        engine.addSystem(new EmptySystem(), 0);
        engine.addSystem(new MockSystem( this ), 0);
        engine.removeAllSystems();
        assertThat(engine.getSystem(MockSystem), nullValue());
        assertThat(engine.getSystem(EmptySystem), nullValue());
    }

    @Test
    public function testremoveSystemAndAddItAgainDontCauseInvalidLinkedList():Void
    {
        var systemB:System = new EmptySystem();
        var systemC:System = new EmptySystem();
        engine.addSystem(systemB, 0);
        engine.addSystem(systemC, 0);
        engine.removeSystem(systemB);
        engine.addSystem(systemB, 0);
        // engine.update( 0.1 ); causes infinite loop in failing test
        assertThat(systemC.previous, nullValue());
        assertThat(systemB.next, nullValue());
    }

    private function addedCallbackMethod(system:System, action:String, systemEngine:Engine):Void
    {
        assertThat(action, equalTo("added"));
        assertThat(systemEngine, sameInstance(engine));
    }

    private function removedCallbackMethod(system:System, action:String, systemEngine:Engine):Void
    {
        assertThat(action, equalTo("removed"));
        assertThat(systemEngine, sameInstance(engine));
    }

    private function updateCallbackMethod(system:System, action:String, time:Float):Void
    {
        assertThat(action, equalTo("update"));
        assertThat(time, equalTo(0.1));
    }

    private function updateCallbackMethod1(system:System, action:String, time:Float):Void
    {
        assertThat(system, equalTo(system1));
        //        asyncCallback = async.createHandler(this, updateCallbackMethod2, 10);
        callBack = updateCallbackMethod2;
    }

    private function updateCallbackMethod2(system:System, action:String, time:Float):Void
    {
        assertThat(system, equalTo(system2));
    }

    private function assertsUpdatingIsTrue(system:System, action:String, time:Float):Void
    {
        assertThat(engine.updating, is(true));
    }
}
