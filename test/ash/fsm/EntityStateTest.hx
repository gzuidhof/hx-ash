package ash.fsm;

import org.hamcrest.MatchersBase;

import ash.fsm.IComponentProvider;
import ash.fsm.ComponentTypeProvider;
import ash.fsm.ComponentSingletonProvider;
import ash.fsm.ComponentInstanceProvider;
import ash.fsm.DynamicComponentProvider.DynamicComponentProviderClosure;
import ash.fsm.EntityState;
import ash.Mocks;

class EntityStateTest extends MatchersBaseTestCase
{
    private var state:EntityState;

    @Before
    override public function setup():Void
    {
        state = new EntityState();
    }

    @After
    override public function tearDown():Void
    {
        state = null;
    }

    @Test
    public function testaddWithNoQualifierCreatesTypeProvider():Void
    {
        state.add(MockComponent);
        var provider:IComponentProvider<MockComponent> = cast state.providers.get(MockComponent);
        assertThat(provider, any(ComponentTypeProvider));
        assertThat(provider.getComponent(), any(MockComponent));
    }

    @Test
    public function testaddWithTypeQualifierCreatesTypeProvider():Void
    {
        state.add(MockComponent).withType(MockComponentExtended);
        var provider:IComponentProvider<MockComponent> = cast state.providers.get(MockComponent);
        assertThat(provider, any(ComponentTypeProvider));
        assertThat(provider.getComponent(), any(MockComponentExtended));
    }

    @Test
    public function testaddWithInstanceQualifierCreatesInstanceProvider():Void
    {
        var component:MockComponent = new MockComponent();
        state.add(MockComponent).withInstance(component);
        var provider:IComponentProvider<MockComponent> = cast state.providers.get(MockComponent);
        assertThat(provider, any(ComponentInstanceProvider));
        assertThat(provider.getComponent(), equalTo(component));
    }

    @Test
    public function testaddWithSingletonQualifierCreatesSingletonProvider():Void
    {
        state.add(MockComponent).withSingleton(MockComponent);
        var provider:IComponentProvider<MockComponent> = cast state.providers.get(MockComponent);
        assertThat(provider, any(ComponentSingletonProvider));
        assertThat(provider.getComponent(), any(MockComponent));
    }

    @Test
    public function testaddWithMethodQualifierCreatesDynamicProvider():Void
    {
        var dynamicProvider:DynamicComponentProviderClosure<MockComponent> = function():MockComponent
        {
            return new MockComponent();
        };
        state.add(MockComponent).withMethod(dynamicProvider);
        var provider:IComponentProvider<MockComponent> = cast state.providers.get(MockComponent);
        assertThat(provider, instanceOf(DynamicComponentProvider));
        assertThat(provider.getComponent(), instanceOf(MockComponent));
    }
}
