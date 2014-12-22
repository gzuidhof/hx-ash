package ash.core;

import MatchersBaseTestCase;
import ash.core.IFamily;
import ash.core.Entity;
import ash.core.Engine;
import ash.core.Node;
import ash.core.NodeList;
import ash.Mocks;
import haxe.unit.TestCase;

class EngineTest extends MatchersBaseTestCase
{
    private var engine:Engine;

    override public function setup():Void
    {
        engine = new Engine();
        engine.familyClass = MockFamily;
        MockFamily.reset();
    }

    override public function tearDown():Void
    {
        engine = null;
    }

    @Test
    public function testEntitiesGetterReturnsAllTheEntities():Void
    {
        var entity1:Entity = new Entity();
        engine.addEntity(entity1);
        var entity2:Entity = new Entity();
        engine.addEntity(entity2);
        assertThat(Lambda.array(engine.entities).length, equalTo(2));
        assertThat(engine.entities, hasItems([entity1, entity2]));
    }

    @Test
    public function testGetEntityByIdReturnsCorrectEntity():Void
    {
        var entity1:Entity = new Entity();
        engine.addEntity(entity1);
        var entity2:Entity = new Entity();
        engine.addEntity(entity2);
        assertThat(engine.getEntityById(entity2.id), sameInstance(entity2));
    }

    @Test
    public function testGetEntityByIdReturnsNullIfNoEntity():Void
    {
        var entity1:Entity = new Entity();
        engine.addEntity(entity1);
        var entity2:Entity = new Entity();
        engine.addEntity(entity2);
        assertThat(engine.getEntityById(-1), is(null));
    }

    @Test
    public function testGetEntityByNameReturnsCorrectEntity():Void
    {
        var entity1:Entity = new Entity();
        entity1.name = "otherEntity";
        engine.addEntity(entity1);
        var entity2:Entity = new Entity();
        entity2.name = "myEntity";
        engine.addEntity(entity2);
        assertThat(engine.getEntityByName("myEntity"), sameInstance(entity2));
    }

    @Test
    public function testGetEntityByNameReturnsNullIfNoEntity():Void
    {
        var entity1:Entity = new Entity();
        entity1.name = "otherEntity";
        engine.addEntity(entity1);
        var entity2:Entity = new Entity();
        entity2.name = "myEntity";
        engine.addEntity(entity2);
        assertThat(engine.getEntityByName("wrongName"), is(null));
    }

    @Test
    public function testAddEntityChecksWithAllFamilies():Void
    {
        engine.getNodeList(MockNode);
        engine.getNodeList(MockNode3);
        var entity:Entity = new Entity();
        engine.addEntity(entity);
        assertThat(MockFamily.instances[0].newEntityCalls, equalTo(1));
        assertThat(MockFamily.instances[1].newEntityCalls, equalTo(1));
    }

    @Test
    public function testRemoveEntityChecksWithAllFamilies():Void
    {
        engine.getNodeList(MockNode);
        engine.getNodeList(MockNode3);
        var entity:Entity = new Entity();
        engine.addEntity(entity);
        engine.removeEntity(entity);
        assertThat(MockFamily.instances[0].removeEntityCalls, equalTo(1));
        assertThat(MockFamily.instances[1].removeEntityCalls, equalTo(1));
    }

    @Test
    public function testRemoveAllEntitiesChecksWithAllFamilies():Void
    {
        engine.getNodeList(MockNode);
        engine.getNodeList(MockNode3);
        var entity:Entity = new Entity();
        var entity2:Entity = new Entity();
        engine.addEntity(entity);
        engine.addEntity(entity2);
        engine.removeAllEntities();
        assertThat(MockFamily.instances[0].removeEntityCalls, equalTo(2));
        assertThat(MockFamily.instances[1].removeEntityCalls, equalTo(2));
    }

    @Test
    public function testComponentAddedChecksWithAllFamilies():Void
    {
        engine.getNodeList(MockNode);
        engine.getNodeList(MockNode3);
        var entity:Entity = new Entity();
        engine.addEntity(entity);
        entity.add(new Point());
        assertThat(MockFamily.instances[0].componentAddedCalls, equalTo(1));
        assertThat(MockFamily.instances[1].componentAddedCalls, equalTo(1));
    }

    @Test
    public function testComponentRemovedChecksWithAllFamilies():Void
    {
        engine.getNodeList(MockNode);
        engine.getNodeList(MockNode3);
        var entity:Entity = new Entity();
        engine.addEntity(entity);
        entity.add(new Point());
        entity.remove(Point);
        assertThat(MockFamily.instances[0].componentRemovedCalls, equalTo(1));
        assertThat(MockFamily.instances[1].componentRemovedCalls, equalTo(1));
    }

    @Test
    public function testGetNodeListCreatesFamily():Void
    {
        engine.getNodeList(MockNode);
        assertThat(MockFamily.instances.length, equalTo(1));
    }

    @Test
    public function testGetNodeListChecksAllEntities():Void
    {
        engine.addEntity(new Entity());
        engine.addEntity(new Entity());
        engine.getNodeList(MockNode);
        assertThat(MockFamily.instances[0].newEntityCalls, equalTo(2));
    }

    @Test
    public function testGeleaseNodeListCallsCleanUp():Void
    {
        engine.getNodeList(MockNode);
        engine.releaseNodeList(MockNode);
        assertThat(MockFamily.instances[0].cleanUpCalls, equalTo(1));
    }

    @Test
    public function testEntityCanBeObtainedByName():Void
    {
        var entity:Entity = new Entity( "anything" );
        engine.addEntity(entity);
        var other:Entity = engine.getEntityByName("anything");
        assertThat(other, sameInstance(entity));
    }

    @Test
    public function testGetEntityByInvalidNameReturnsNull():Void
    {
        var entity:Entity = engine.getEntityByName("anything");
        assertThat(entity, nullValue());
    }

    @Test
    public function testEntityCanBeObtainedByNameAfterRenaming():Void
    {
        var entity:Entity = new Entity( "anything" );
        engine.addEntity(entity);
        entity.name = "otherName";
        var other:Entity = engine.getEntityByName("otherName");
        assertThat(other, sameInstance(entity));
    }

    @Test
    public function testEntityCannotBeObtainedByOldNameAfterRenaming():Void
    {
        var entity:Entity = new Entity( "anything" );
        engine.addEntity(entity);
        entity.name = "otherName";
        var other:Entity = engine.getEntityByName("anything");
        assertThat(other, nullValue());
    }
}

class MockFamily<T:Node<T>> implements IFamily<T>
{
    public static function reset():Void
    {
        instances = new Array<MockFamily<Dynamic>>();
    }
    public static var instances:Array<MockFamily<Dynamic>>;

    public var newEntityCalls:Int = 0;
    public var removeEntityCalls:Int = 0;
    public var componentAddedCalls:Int = 0;
    public var componentRemovedCalls:Int = 0;
    public var cleanUpCalls:Int = 0;

	@:keep
    public function new(nodeClass:Class<T>, engine:Engine)
    {
        instances.push(this);
    }

    public var nodeList(default, never):NodeList<T>;

    public function newEntity(entity:Entity):Void
    {
        newEntityCalls++;
    }

    public function removeEntity(entity:Entity):Void
    {
        removeEntityCalls++;
    }

    public function componentAddedToEntity(entity:Entity, componentClass:Class<Dynamic>):Void
    {
        componentAddedCalls++;
    }

    public function componentRemovedFromEntity(entity:Entity, componentClass:Class<Dynamic>):Void
    {
        componentRemovedCalls++;
    }

    public function cleanUp():Void
    {
        cleanUpCalls++;
    }
}
