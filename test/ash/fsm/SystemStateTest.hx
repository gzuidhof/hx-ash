package ash.fsm;

import ash.fsm.DynamicSystemProvider.DynamicSystemProviderClosure;
import ash.Mocks.EmptySystem;

import org.hamcrest.MatchersBase;


class SystemStateTest extends MatchersBaseTestCase
{
    private var state:EngineState;

    @Before
    override public function setup():Void
    {
        state = new EngineState();
    }

    @After
    override public function tearDown():Void
    {
        state = null;
    }

    @Test
    public function testaddInstanceCreatesInstanceProvider():Void
    {
        var component:EmptySystem = new EmptySystem();
        state.addInstance(component);
        var provider:ISystemProvider<EmptySystem> = cast state.providers[0];
        assertThat(provider, instanceOf(SystemInstanceProvider));
        assertThat(provider.getSystem(), equalTo(component));
    }

    @Test
    public function testaddSingletonCreatesSingletonProvider():Void
    {
        state.addSingleton(EmptySystem);
        var provider:ISystemProvider<EmptySystem> = cast state.providers[0];
        assertThat(provider, instanceOf(SystemSingletonProvider));
        assertThat(provider.getSystem(), instanceOf(EmptySystem));
    }

    @Test
    public function testaddMethodCreatesMethodProvider():Void
    {
        var instance:EmptySystem = new EmptySystem();

        var methodProvider:DynamicSystemProviderClosure<EmptySystem> = function():EmptySystem
        {
            return instance;
        };

        state.addMethod(methodProvider);
        var provider:ISystemProvider<EmptySystem> = cast state.providers[0];
        assertThat(provider, instanceOf(DynamicSystemProvider));
        assertThat(provider.getSystem(), instanceOf(EmptySystem));
    }

    @Test
    public function testwithPrioritySetsPriorityOnProvider():Void
    {
        var priority:Int = 10;
        state.addSingleton(EmptySystem).withPriority(priority);
        var provider:ISystemProvider<EmptySystem> = cast state.providers[0];
        assertThat(provider.priority, equalTo(priority));

    }
}
