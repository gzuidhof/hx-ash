package ash.core;

import org.hamcrest.MatchersBase;

import ash.core.NodeList;
import ash.core.Node;
import ash.matchers.NodeListMatcher;
import ash.Mocks;

class NodeListTest extends MatchersBaseTestCase
{
    private var nodes:NodeList<MockNode2>;

    @Before
    override public function setup():Void
    {
        nodes = new NodeList<MockNode2>();
    }

    @Afters
    override public function tearDown():Void
    {
        nodes = null;
    }

    private function shouldCall():ShouldCallHelper<MockNode2->Void>
    {
        return new ShouldCallHelper(function(n) {});
    }

    @Test
    public function testAddingNodeTriggersAddedSignal():Void
    {
        var h = shouldCall();
        var node:MockNode2 = Type.createEmptyInstance(MockNode2);
        nodes.nodeAdded.add(h.func);
        nodes.add(node);
        assertTrue(h.assertIsCalled());
    }

    @Test
    public function testremovingNodeTriggersRemovedSignal():Void
    {
        var h = shouldCall();
        var node:MockNode2 = Type.createEmptyInstance(MockNode2);
        nodes.add(node);
        nodes.nodeRemoved.add(h.func);
        nodes.remove(node);
        assertTrue(h.assertIsCalled());
    }

    @Test
    public function testAllNodesAreCoveredDuringIteration():Void
    {
        var nodeArray:Array<MockNode2> = [];
        for (i in 0...5)
        {
            var node:MockNode2 = Type.createEmptyInstance(MockNode2);
            nodeArray.push(node);
            nodes.add(node);
        }

        for (node in nodes)
        {
            var index:Int = Lambda.indexOf(nodeArray, node);
            nodeArray.splice(index, 1);
        }
		assertTrue(nodeArray.length == 0);
        //assertThat(nodeArray, emptyArray());
    }

    @Test
    public function testremovingCurrentNodeDuringIterationIsValid():Void
    {
        var nodeArray:Array<MockNode2> = [];
        for (i in 0...5)
        {
            var node:MockNode2 = Type.createEmptyInstance(MockNode2);
            nodeArray.push(node);
            nodes.add(node);
        }

        var count:Int = 0;
        for (node in nodes)
        {
            var index:Int = Lambda.indexOf(nodeArray, node);
            nodeArray.splice(index, 1);
            if (++count == 2)
            {
                nodes.remove(node);
            }
        }
		assertTrue(nodeArray.length == 0);
    }

    @Test
    public function testremovingNextNodeDuringIterationIsValid():Void
    {
        var nodeArray:Array<MockNode2> = [];
        for (i in 0...5)
        {
            var node:MockNode2 = Type.createEmptyInstance(MockNode2);
            nodeArray.push(node);
            nodes.add(node);
        }

        var count:Int = 0;
        for (node in nodes)
        {
            var index:Int = Lambda.indexOf(nodeArray, node);
            nodeArray.splice(index, 1);
            if (++count == 2)
            {
                nodes.remove(node.next);
            }
        }
        assertThat(nodeArray.length, equalTo(1));
    }

    private var tempNode:MockNode2;

    @Test
    public function testcomponentAddedSignalContainsCorrectParameters():Void
    {
        tempNode = Type.createEmptyInstance(MockNode2);
        nodes.nodeAdded.add(atestSignalContent);
        nodes.add(tempNode);
    }

    @Test
    public function testcomponentRemovedSignalContainsCorrectParameters():Void
    {
        tempNode = Type.createEmptyInstance(MockNode2);
        nodes.add(tempNode);
        nodes.nodeRemoved.add(atestSignalContent);
        nodes.remove(tempNode);
    }

    private function atestSignalContent(signalNode:MockNode2):Void
    {
        assertThat(signalNode, sameInstance(tempNode));
    }

    @Test
    public function testnodesInitiallySortedInOrderOfAddition():Void
    {
        var node1:MockNode2 = Type.createEmptyInstance(MockNode2);
        var node2:MockNode2 = Type.createEmptyInstance(MockNode2);
        var node3:MockNode2 = Type.createEmptyInstance(MockNode2);
        nodes.add(node1);
        nodes.add(node2);
        nodes.add(node3);
        assertThat(nodes, NodeListMatcher.nodeList([node1, node2, node3]));
    }

    @Test
    public function testswappingOnlyTwoNodesChangesTheirOrder():Void
    {
        var node1:MockNode2 = Type.createEmptyInstance(MockNode2);
        var node2:MockNode2 = Type.createEmptyInstance(MockNode2);
        nodes.add(node1);
        nodes.add(node2);
        nodes.swap(node1, node2);
        assertThat(nodes, NodeListMatcher.nodeList([node2, node1]));
    }

    @Test
    public function testswappingAdjacentNodesChangesTheirPositions():Void
    {
        var node1:MockNode2 = Type.createEmptyInstance(MockNode2);
        var node2:MockNode2 = Type.createEmptyInstance(MockNode2);
        var node3:MockNode2 = Type.createEmptyInstance(MockNode2);
        var node4:MockNode2 = Type.createEmptyInstance(MockNode2);
        nodes.add(node1);
        nodes.add(node2);
        nodes.add(node3);
        nodes.add(node4);
        nodes.swap(node2, node3);
        assertThat(nodes, NodeListMatcher.nodeList([node1, node3, node2, node4]));
    }

    @Test
    public function testswappingNonAdjacentNodesChangesTheirPositions():Void
    {
        var node1:MockNode2 = Type.createEmptyInstance(MockNode2);
        var node2:MockNode2 = Type.createEmptyInstance(MockNode2);
        var node3:MockNode2 = Type.createEmptyInstance(MockNode2);
        var node4:MockNode2 = Type.createEmptyInstance(MockNode2);
        var node5:MockNode2 = Type.createEmptyInstance(MockNode2);
        nodes.add(node1);
        nodes.add(node2);
        nodes.add(node3);
        nodes.add(node4);
        nodes.add(node5);
        nodes.swap(node2, node4);
        assertThat(nodes, NodeListMatcher.nodeList([node1, node4, node3, node2, node5]));
    }

    @Test
    public function testswappingEndNodesChangesTheirPositions():Void
    {
        var node1:MockNode2 = Type.createEmptyInstance(MockNode2);
        var node2:MockNode2 = Type.createEmptyInstance(MockNode2);
        var node3:MockNode2 = Type.createEmptyInstance(MockNode2);
        nodes.add(node1);
        nodes.add(node2);
        nodes.add(node3);
        nodes.swap(node1, node3);
        assertThat(nodes, NodeListMatcher.nodeList([node3, node2, node1]));
    }

    @Test
    public function testinsertionSortCorrectlySortsSortedNodes():Void
    {
        var nodes:NodeList<MockNode4> = new NodeList();
        var node1:MockNode4 = new MockNode4( 1 );
        var node2:MockNode4 = new MockNode4( 2 );
        var node3:MockNode4 = new MockNode4( 3 );
        var node4:MockNode4 = new MockNode4( 4 );
        nodes.add(node1);
        nodes.add(node2);
        nodes.add(node3);
        nodes.add(node4);
        nodes.insertionSort(sortFunction);
        assertThat(nodes, NodeListMatcher.nodeList([node1, node2, node3, node4]));
    }

    @Test
    public function testinsertionSortCorrectlySortsReversedNodes():Void
    {
        var nodes:NodeList<MockNode4> = new NodeList();
        var node1:MockNode4 = new MockNode4( 1 );
        var node2:MockNode4 = new MockNode4( 2 );
        var node3:MockNode4 = new MockNode4( 3 );
        var node4:MockNode4 = new MockNode4( 4 );
        nodes.add(node4);
        nodes.add(node3);
        nodes.add(node2);
        nodes.add(node1);
        nodes.insertionSort(sortFunction);
        assertThat(nodes, NodeListMatcher.nodeList([node1, node2, node3, node4]));
    }

    @Test
    public function testinsertionSortCorrectlySortsMixedNodes():Void
    {
        var nodes:NodeList<MockNode4> = new NodeList();
        var node1:MockNode4 = new MockNode4( 1 );
        var node2:MockNode4 = new MockNode4( 2 );
        var node3:MockNode4 = new MockNode4( 3 );
        var node4:MockNode4 = new MockNode4( 4 );
        var node5:MockNode4 = new MockNode4( 5 );
        nodes.add(node3);
        nodes.add(node4);
        nodes.add(node1);
        nodes.add(node5);
        nodes.add(node2);
        nodes.insertionSort(sortFunction);
        assertThat(nodes, NodeListMatcher.nodeList([node1, node2, node3, node4, node5]));
    }

    @Test
    public function testinsertionSortRetainsTheOrderOfEquivalentNodes():Void
    {
        var nodes:NodeList<MockNode4> = new NodeList();
        var node1:MockNode4 = new MockNode4( 1 );
        var node2:MockNode4 = new MockNode4( 1 );
        var node3:MockNode4 = new MockNode4( 3 );
        var node4:MockNode4 = new MockNode4( 4 );
        var node5:MockNode4 = new MockNode4( 4 );
        nodes.add(node3);
        nodes.add(node4);
        nodes.add(node1);
        nodes.add(node5);
        nodes.add(node2);
        nodes.insertionSort(sortFunction);
        assertThat(nodes, NodeListMatcher.nodeList([node1, node2, node3, node4, node5]));
    }

    @Test
    public function testmergeSortCorrectlySortsSortedNodes():Void
    {
        var nodes:NodeList<MockNode4> = new NodeList();
        var node1:MockNode4 = new MockNode4( 1 );
        var node2:MockNode4 = new MockNode4( 2 );
        var node3:MockNode4 = new MockNode4( 3 );
        var node4:MockNode4 = new MockNode4( 4 );
        nodes.add(node1);
        nodes.add(node2);
        nodes.add(node3);
        nodes.add(node4);
        nodes.mergeSort(sortFunction);
        assertThat(nodes, NodeListMatcher.nodeList([node1, node2, node3, node4]));
    }

    @Test
    public function testmergeSortCorrectlySortsReversedNodes():Void
    {
        var nodes:NodeList<MockNode4> = new NodeList();
        var node1:MockNode4 = new MockNode4( 1 );
        var node2:MockNode4 = new MockNode4( 2 );
        var node3:MockNode4 = new MockNode4( 3 );
        var node4:MockNode4 = new MockNode4( 4 );
        nodes.add(node4);
        nodes.add(node3);
        nodes.add(node2);
        nodes.add(node1);
        nodes.mergeSort(sortFunction);
        assertThat(nodes, NodeListMatcher.nodeList([node1, node2, node3, node4]));
    }

    @Test
    public function testmergeSortCorrectlySortsMixedNodes():Void
    {
        var nodes:NodeList<MockNode4> = new NodeList();
        var node1:MockNode4 = new MockNode4( 1 );
        var node2:MockNode4 = new MockNode4( 2 );
        var node3:MockNode4 = new MockNode4( 3 );
        var node4:MockNode4 = new MockNode4( 4 );
        var node5:MockNode4 = new MockNode4( 5 );
        nodes.add(node3);
        nodes.add(node4);
        nodes.add(node1);
        nodes.add(node5);
        nodes.add(node2);
        nodes.mergeSort(sortFunction);
        assertThat(nodes, NodeListMatcher.nodeList([node1, node2, node3, node4, node5]));
    }

    private function sortFunction(node1:MockNode4, node2:MockNode4):Int
    {
        return node1.pos.value - node2.pos.value;
    }
}
