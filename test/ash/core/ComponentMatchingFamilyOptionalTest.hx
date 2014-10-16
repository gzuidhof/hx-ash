package ash.core;

import org.hamcrest.MatchersBase;

import ash.core.Entity;
import ash.core.ComponentMatchingFamily;
import ash.core.Engine;
import ash.core.Node;
import ash.Mocks;

class ComponentMatchingFamilyOptionalTest extends MatchersBaseTestCase
{
    private var engine:Engine;
    private var family:ComponentMatchingFamily<MockNodeOpt>;

    @Before
    override public function setup():Void
    {
        engine = new Engine();
        family = new ComponentMatchingFamily( MockNodeOpt, engine );
    }

    @After
    override public function tearDown():Void
    {
        family = null;
        engine = null;
    }

    @Test
    public function testNodeListIsInitiallyEmpty():Void
    {
        var nodes = family.nodeList;
        assertThat(nodes.head, nullValue());
    }

    @Test
    public function testNonMatchingEntityWithOptIsNotAdded():Void
    {
        var nodes = family.nodeList;
        var entity:Entity = new Entity();
        entity.add(new Matrix());
        family.newEntity(entity);
        assertThat(nodes.head, nullValue());
    }

    @Test
    public function testMatchingEntityIsAddedWhenAccessNodeListFirst():Void
    {
        var nodes = family.nodeList;
        var entity:Entity = new Entity();
        entity.add(new Point());
        family.newEntity(entity);
        assertThat(nodes.head.entity, sameInstance(entity));
    }

    @Test
    public function testMatchingEntityWithOptIsAddedWhenAccessNodeListFirst():Void
    {
        var nodes = family.nodeList;
        var entity:Entity = new Entity();
        entity.add(new Point());
        entity.add(new Matrix());
        family.newEntity(entity);
        assertThat(nodes.head.entity, sameInstance(entity));
    }

    @Test
    public function testMatchingEntityIsAddedWhenAccessNodeListSecond():Void
    {
        var entity:Entity = new Entity();
        entity.add(new Point());
        family.newEntity(entity);
        var nodes = family.nodeList;
        assertThat(nodes.head.entity, sameInstance(entity));
    }

    @Test
    public function testMatchingEntityWithOptIsAddedWhenAccessNodeListSecond():Void
    {
        var entity:Entity = new Entity();
        entity.add(new Point());
        entity.add(new Matrix());
        family.newEntity(entity);
        var nodes = family.nodeList;
        assertThat(nodes.head.entity, sameInstance(entity));
    }

    @Test
    public function testNodeContainsEntityProperties():Void
    {
        var entity:Entity = new Entity();
        var point:Point = new Point();
        entity.add(point);
        family.newEntity(entity);
        var nodes = family.nodeList;
        assertThat(nodes.head.point, sameInstance(point));
        assertThat(nodes.head.optMatrix, nullValue());
    }

    @Test
    public function testNodeContainsEntityPropertiesIncludingOpt():Void
    {
        var entity:Entity = new Entity();
        var point:Point = new Point();
        var optMatrix:Matrix = new Matrix();
        entity.add(point);
        entity.add(optMatrix);
        family.newEntity(entity);
        var nodes = family.nodeList;
        assertThat(nodes.head.point, sameInstance(point));
        assertThat(nodes.head.optMatrix, sameInstance(optMatrix));
    }

    @Test
    public function testMatchingEntityIsAddedWhenComponentAdded():Void
    {
        var nodes = family.nodeList;
        var entity:Entity = new Entity();
        entity.add(new Point());
        family.componentAddedToEntity(entity, Point);
        assertThat(nodes.head.entity, sameInstance(entity));
    }

    @Test
    public function testNonMatchingEntityIsNotAdded():Void
    {
        var entity:Entity = new Entity();
        family.newEntity(entity);
        var nodes = family.nodeList;
        assertThat(nodes.head, nullValue());
    }

    @Test
    public function testNonMatchingEntityIsNotAddedWhenComponentAdded():Void
    {
        var entity:Entity = new Entity();
        entity.add(new Matrix());
        family.componentAddedToEntity(entity, Matrix);
        var nodes = family.nodeList;
        assertThat(nodes.head, nullValue());
    }

    @Test
    public function testEntityIsRemovedWhenAccessNodeListFirst():Void
    {
        var entity:Entity = new Entity();
        entity.add(new Point());
        family.newEntity(entity);
        var nodes = family.nodeList;
        family.removeEntity(entity);
        assertThat(nodes.head, nullValue());
    }

    @Test
    public function testEntityWithOptIsRemovedWhenAccessNodeListFirst():Void
    {
        var entity:Entity = new Entity();
        entity.add(new Point());
        entity.add(new Matrix());
        family.newEntity(entity);
        var nodes = family.nodeList;
        family.removeEntity(entity);
        assertThat(nodes.head, nullValue());
    }

    @Test
    public function testEntityIsRemovedWhenAccessNodeListSecond():Void
    {
        var entity:Entity = new Entity();
        entity.add(new Point());
        family.newEntity(entity);
        family.removeEntity(entity);
        var nodes = family.nodeList;
        assertThat(nodes.head, nullValue());
    }

    @Test
    public function testEntityWithOptIsRemovedWhenAccessNodeListSecond():Void
    {
        var entity:Entity = new Entity();
        entity.add(new Point());
        entity.add(new Matrix());
        family.newEntity(entity);
        family.removeEntity(entity);
        var nodes = family.nodeList;
        assertThat(nodes.head, nullValue());
    }

    @Test
    public function testEntityIsRemovedWhenComponentRemoved():Void
    {
        var entity:Entity = new Entity();
        entity.add(new Point());
        family.newEntity(entity);
        entity.remove(Point);
        family.componentRemovedFromEntity(entity, Point);
        var nodes = family.nodeList;
        assertThat(nodes.head, nullValue());
    }

    @Test
    public function testEntityIsNotRemovedWhenOptComponentRemoved():Void
    {
        var entity:Entity = new Entity();
        entity.add(new Point());
        entity.add(new Matrix());
        family.newEntity(entity);
        entity.remove(Matrix);
        family.componentRemovedFromEntity(entity, Matrix);
        var nodes = family.nodeList;
        assertThat(nodes.head.entity, sameInstance(entity));
        assertThat(nodes.head.optMatrix, nullValue());
    }

    @Test
    public function testEntityWithOptIsRemovedWhenComponentRemoved():Void
    {
        var entity:Entity = new Entity();
        entity.add(new Point());
        entity.add(new Matrix());
        family.newEntity(entity);
        entity.remove(Point);
        family.componentRemovedFromEntity(entity, Point);
        var nodes = family.nodeList;
        assertThat(nodes.head, nullValue());
    }

    @Test
    public function testNodeListContainsOnlyMatchingEntities():Void
    {
        var entities:Array<Entity> = [];
        for (i in 0...5)
        {
            var entity:Entity = new Entity();
            entity.add(new Point());
            entities.push(entity);
            family.newEntity(entity);
            family.newEntity(new Entity());
        }

        var nodes = family.nodeList;
        for (node in nodes)
        {
            assertThat(entities, hasItem(node.entity));
        }
    }

    @Test
    public function testNodeListWithOptsContainsOnlyMatchingEntities():Void
    {
        var entities:Array<Entity> = [];
        for (i in 0...5)
        {
            var entity:Entity = new Entity();
            entity.add(new Point());
            entity.add(new Matrix());
            entities.push(entity);
            family.newEntity(entity);
            family.newEntity(new Entity());
        }

        var nodes = family.nodeList;
        for (node in nodes)
        {
            assertThat(entities, hasItem(node.entity));
        }
    }

    @Test
    public function testNodeListContainsAllMatchingEntities():Void
    {
        var entities:Array<Entity> = [];
        for (i in 0...5)
        {
            var entity:Entity = new Entity();
            entity.add(new Point());
            entities.push(entity);
            family.newEntity(entity);
            family.newEntity(new Entity());
        }

        var nodes = family.nodeList;
        for (node in nodes)
        {
            var index:Int = Lambda.indexOf(entities, node.entity);
            entities.splice(index, 1);
        }
        assertThat(entities, emptyArray());
    }

    @Test
    public function testNodeListWithOptContainsAllMatchingEntities():Void
    {
        var entities:Array<Entity> = [];
        for (i in 0...5)
        {
            var entity:Entity = new Entity();
            entity.add(new Point());
            entity.add(new Matrix());
            entities.push(entity);
            family.newEntity(entity);
            family.newEntity(new Entity());
        }

        var nodes = family.nodeList;
        for (node in nodes)
        {
            var index:Int = Lambda.indexOf(entities, node.entity);
            entities.splice(index, 1);
        }
        assertThat(entities, emptyArray());
    }

    @Test
    public function testCleanUpEmptiesNodeList():Void
    {
        var entity:Entity = new Entity();
        entity.add(new Point());
        entity.add(new Matrix());
        family.newEntity(entity);
        var nodes = family.nodeList;
        family.cleanUp();
        assertThat(nodes.head, nullValue());
    }

    @Test
    public function testCleanUpSetsNextNodeToNull():Void
    {
        var entities:Array<Entity> = [];
        for (i in 0...5)
        {
            var entity:Entity = new Entity();
            entity.add(new Point());
            entity.add(new Matrix());
            entities.push(entity);
            family.newEntity(entity);
        }

        var nodes = family.nodeList;
        var node:MockNodeOpt = nodes.head.next;
        family.cleanUp();
        assertThat(node.next, nullValue());
    }
}
