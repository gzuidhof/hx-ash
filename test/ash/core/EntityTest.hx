package ash.core;

import org.hamcrest.MatchersBase;

import ash.core.Entity;
import ash.Mocks;

class EntityTest extends MatchersBaseTestCase
{
    private var entity:Entity;

    @Before
    override public function setup():Void
    {
        entity = new Entity();
    }

    @After
    override public function tearDown():Void
    {
        entity = null;
    }

    private function shouldCall<T>(f:T):ShouldCallHelper<T>
    {
        return new ShouldCallHelper(f, this);
    }

    @Test
    public function testEntityIdsAreSequential():Void
    {
        var id = entity.id;
        var entity2 = new Entity();
        assertThat(entity2.id, equalTo(id + 1));
    }

    @Test
    public function testAddReturnsReferenceToEntity():Void
    {
        var component:MockComponent = new MockComponent();
        var e:Entity = entity.add(component);
        assertThat(e, sameInstance(entity));
    }

    @Test
    public function testCanStoreAndRetrieveComponent():Void
    {
        var component:MockComponent = new MockComponent();
        entity.add(component);
        assertThat(entity.get(MockComponent), sameInstance(component));
    }

    @Test
    public function testCanStoreAndRetrieveMultipleComponents():Void
    {
        var component1:MockComponent = new MockComponent();
        entity.add(component1);
        var component2:MockComponent2 = new MockComponent2();
        entity.add(component2);
        assertThat(entity.get(MockComponent), sameInstance(component1));
        assertThat(entity.get(MockComponent2), sameInstance(component2));
    }

    @Test
    public function testCanReplaceComponent():Void
    {
        var component1:MockComponent = new MockComponent();
        entity.add(component1);
        var component2:MockComponent = new MockComponent();
        entity.add(component2);
        assertThat(entity.get(MockComponent), sameInstance(component2));
    }

    @Test
    public function testCanStoreBaseAndExtendedComponents():Void
    {
        var component1:MockComponent = new MockComponent();
        entity.add(component1);
        var component2:MockComponentExtended = new MockComponentExtended();
        entity.add(component2);
        assertThat(entity.get(MockComponent), sameInstance(component1));
        assertThat(entity.get(MockComponentExtended), sameInstance(component2));
    }

    @Test
    public function testcanStoreExtendedComponentAsBaseType():Void
    {
        var component:MockComponentExtended = new MockComponentExtended();
        entity.add(component, MockComponent);
        assertThat(entity.get(MockComponent), sameInstance(component));
    }

    @Test
    public function testgetReturnNullIfNoComponent():Void
    {
        assertThat(entity.get(MockComponent), nullValue());
    }

    @Test
    public function testwillRetrieveAllComponents():Void
    {
        var component1:MockComponent = new MockComponent();
        entity.add(component1);
        var component2:MockComponent2 = new MockComponent2();
        entity.add(component2);
        var all:Array<Dynamic> = entity.getAll();
        assertThat(all.length, equalTo(2));

        var components:Array<Dynamic> = [component1, component2];
        assertThat(all, hasItems(components));
    }

    @Test
    public function testhasComponentIsFalseIfComponentTypeNotPresent():Void
    {
        entity.add(new MockComponent2());
        assertThat(entity.has(MockComponent), is(false));
    }

    @Test
    public function testhasComponentIsTrueIfComponentTypeIsPresent():Void
    {
        entity.add(new MockComponent());
        assertThat(entity.has(MockComponent), is(true));
    }

    @Test
    public function testcanRemoveComponent():Void
    {
        var component:MockComponent = new MockComponent();
        entity.add(component);
        entity.remove(MockComponent);
        assertThat(entity.has(MockComponent), is(false));
    }
	/* Requires rewrite for java target. Unspecified behaviour using the shouldCall function.
    @Test
    public function teststoringComponentTriggersAddedSignal():Void
    {
        var h = shouldCall(function(e, c) {});
        var component:MockComponent = new MockComponent();
        entity.componentAdded.add(h.func);
        entity.add(component);
        assertTrue(h.assertIsCalled());
    }

    @Test
    public function testremovingComponentTriggersRemovedSignal():Void
    {
        var h = shouldCall(function(e, c) {});
        var component:MockComponent = new MockComponent();
        entity.add(component);
        entity.componentRemoved.add(h.func);
        entity.remove(MockComponent);
        assertTrue(h.assertIsCalled());
    }*/
	
    @Test
    public function testcomponentAddedSignalContainsCorrectParameters():Void
    {
        var component:MockComponent = new MockComponent();
        entity.componentAdded.add(atestSignalContent);
        entity.add(component);
    }

    @Test
    public function testcomponentRemovedSignalContainsCorrectParameters():Void
    {
        var component:MockComponent = new MockComponent();
        entity.add(component);
        entity.componentRemoved.add(atestSignalContent);
        entity.remove(MockComponent);
    }

    private function atestSignalContent(signalEntity:Entity, componentClass:Class<Dynamic>):Void
    {
        assertThat(signalEntity, sameInstance(entity));
        assertThat(componentClass, sameInstance(MockComponent));
    }

    @Test
    public function testEntityHasNameByDefault():Void
    {
        entity = new Entity();
        assertThat(entity.name.length, greaterThan(0));
    }

    @Test
    public function testEntityNameStoredAndReturned():Void
    {
        var name:String = "anything";
        entity = new Entity( name );
        assertThat(entity.name, equalTo(name));
    }

    @Test
    public function testEntityNameCanBeChanged():Void
    {
        entity = new Entity( "anything" );
        entity.name = "otherThing";
        assertThat(entity.name, equalTo("otherThing"));
    }

    @Test
    public function testChangingEntityNameDispatchesSignal():Void
    {
        var h = shouldCall(atestNameChangedSignal);
        entity = new Entity( "anything" );
        entity.nameChanged.add(h.func);
        entity.name = "otherThing";
        assertTrue(h.assertIsCalled());
    }

    private function atestNameChangedSignal(signalEntity:Entity, oldName:String):Void
    {
        assertThat(signalEntity, sameInstance(entity));
        assertThat(entity.name, equalTo("otherThing"));
        assertThat(oldName, equalTo("anything"));
    }
}
