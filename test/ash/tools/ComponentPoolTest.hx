package ash.tools;

import org.hamcrest.MatchersBase;

import ash.tools.ComponentPool;
import ash.Mocks;

class ComponentPoolTest extends MatchersBaseTestCase
{
    @After
    override public function tearDown():Void
    {
        ComponentPool.empty();
    }

    @Test
    public function testgetRetrievesObjectOfAppropriateClass():Void
    {
        assertThat(ComponentPool.get(MockComponent), is(MockComponent));
    }

    @Test
    public function testdisposedComponentsAreRetrievedByGet():Void
    {
        var mockComponent:MockComponent = new MockComponent();
        ComponentPool.dispose(mockComponent);
        var retrievedComponent:MockComponent = ComponentPool.get(MockComponent);
        assertThat(retrievedComponent, sameInstance(mockComponent));
    }

    @Test
    public function testemptyPreventsRetrievalOfPreviouslyDisposedComponents():Void
    {
        var mockComponent:MockComponent = new MockComponent();
        ComponentPool.dispose(mockComponent);
        ComponentPool.empty();
        var retrievedComponent:MockComponent = ComponentPool.get(MockComponent);
        assertThat(retrievedComponent, not(sameInstance(mockComponent)));
    }
}
