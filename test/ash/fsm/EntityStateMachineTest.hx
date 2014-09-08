package ash.fsm;

import org.hamcrest.MatchersBase;

import ash.core.Entity;
import ash.fsm.EntityStateMachine;
import ash.fsm.EntityState;
import ash.Mocks;

class EntityStateMachineTest extends MatchersBaseTestCase
{
    private var fsm:EntityStateMachine;
    private var entity:Entity;

    @Before
    override public function setup():Void
    {
        entity = new Entity();
        fsm = new EntityStateMachine( entity );
    }

    @After
    override public function tearDown():Void
    {
        entity = null;
        fsm = null;
    }

    @Test
    public function testenterStateAddsStatesComponents():Void
    {
        var state:EntityState = new EntityState();
        var component:MockComponent = new MockComponent();
        state.add(MockComponent).withInstance(component);
        fsm.addState("test", state);
        fsm.changeState("test");
        assertThat(entity.get(MockComponent), sameInstance(component));
    }

    @Test
    public function testenterSecondStateAddsSecondStatesComponents():Void
    {
        var state1:EntityState = new EntityState();
        var component1:MockComponent = new MockComponent();
        state1.add(MockComponent).withInstance(component1);
        fsm.addState("test1", state1);
        fsm.changeState("test1");

        var state2:EntityState = new EntityState();
        var component2:MockComponent2 = new MockComponent2();
        state2.add(MockComponent2).withInstance(component2);
        fsm.addState("test2", state2);
        fsm.changeState("test2");

        assertThat(entity.get(MockComponent2), sameInstance(component2));
    }

    @Test
    public function testenterSecondStateRemovesFirstStatesComponents():Void
    {
        var state1:EntityState = new EntityState();
        var component1:MockComponent = new MockComponent();
        state1.add(MockComponent).withInstance(component1);
        fsm.addState("test1", state1);
        fsm.changeState("test1");

        var state2:EntityState = new EntityState();
        var component2:MockComponent2 = new MockComponent2();
        state2.add(MockComponent2).withInstance(component2);
        fsm.addState("test2", state2);
        fsm.changeState("test2");

        assertThat(entity.has(MockComponent), is(false));
    }

    @Test
    public function testenterSecondStateDoesNotRemoveOverlappingComponents():Void
    {
        entity.componentRemoved.add(failIfCalled);

        var state1:EntityState = new EntityState();
        var component1:MockComponent = new MockComponent();
        state1.add(MockComponent).withInstance(component1);
        fsm.addState("test1", state1);
        fsm.changeState("test1");

        var state2:EntityState = new EntityState();
        var component2:MockComponent2 = new MockComponent2();
        state2.add(MockComponent).withInstance(component1);
        state2.add(MockComponent2).withInstance(component2);
        fsm.addState("test2", state2);
        fsm.changeState("test2");

        assertThat(entity.get(MockComponent), sameInstance(component1));
    }

    @Test
    public function testenterSecondStateRemovesDifferentComponentsOfSameType():Void
    {
        var state1:EntityState = new EntityState();
        var component1:MockComponent = new MockComponent();
        state1.add(MockComponent).withInstance(component1);
        fsm.addState("test1", state1);
        fsm.changeState("test1");

        var state2:EntityState = new EntityState();
        var component3:MockComponent = new MockComponent();
        var component2:MockComponent2 = new MockComponent2();
        state2.add(MockComponent).withInstance(component3);
        state2.add(MockComponent2).withInstance(component2);
        fsm.addState("test2", state2);
        fsm.changeState("test2");

        assertThat(entity.get(MockComponent), sameInstance(component3));
    }

    private static function failIfCalled(entity:Entity, component:Dynamic):Void
    {
		throw "Component was removed when it shouldn't have been.";
    }
}
