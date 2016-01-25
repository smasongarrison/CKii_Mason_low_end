Samplers = 
{
	HeightTexture = {
		Index = 0;
		MagFilter = "Linear";
		MipFilter = "Linear";
		MinFilter = "Linear";
		AddressU = "Wrap";
		AddressV = "Wrap";
	},
	WaterNormal = {
		Index = 1;
		MagFilter = "Linear";
		MipFilter = "Linear";
		MinFilter = "Linear";
		AddressU = "Wrap";
		AddressV = "Wrap";
	},
	ReflectionCubeMap = {
		Index = 2;
		MagFilter = "Linear";
		MipFilter = "Linear";
		MinFilter = "Linear";
		AddressU = "Mirror";
		AddressV = "Mirror";
		Type = "Cube";
	},
	WaterColor = {
		Index = 3;
		MagFilter = "Linear";
		MipFilter = "Linear";
		MinFilter = "Linear";
		AddressU = "Wrap";
		AddressV = "Wrap";
	},
	WaterNoise = {
		Index = 4;
		MagFilter = "Linear";
		MipFilter = "Linear";
		MinFilter = "Linear";
		AddressU = "Wrap";
		AddressV = "Wrap";
	},
	WaterRefraction = {
		Index = 5;
		MagFilter = "Linear";
		MipFilter = "Linear";
		MinFilter = "Linear";
		AddressU = "Clamp";
		AddressV = "Clamp";
	},
	FoWTexture = {
		Index = 6;
		MagFilter = "Linear";
		MipFilter = "Linear";
		MinFilter = "Linear";
		AddressU = "Wrap";
		AddressV = "Wrap";
	},
	FoWDiffuse = {
		Index = 7;
		MagFilter = "Linear";
		MipFilter = "Linear";
		MinFilter = "Linear";
		AddressU = "Wrap";
		AddressV = "Wrap";
	},
	ProvinceColorMap = {
		Index = 8;
		MagFilter = "Linear";
		MipFilter = "Linear";
		MinFilter = "Linear";
		AddressU = "Clamp";
		AddressV = "Clamp";
	},
	IceDiffuse = {
		Index = 9;
		MagFilter = "Linear";
		MipFilter = "Linear";
		MinFilter = "Linear";
		AddressU = "Wrap";
		AddressV = "Wrap";
	},
	IceNormal = {
		Index = 10;
		MagFilter = "Linear";
		MipFilter = "Linear";
		MinFilter = "Linear";
		AddressU = "Wrap";
		AddressV = "Wrap";
	}
}
AddSamplers()

Includes = {
	"standardfuncsgfx.fxh",
	"pdxmap.fxh"
}


BlendState =
{
	WriteMask = "RED|GREEN|BLUE";
	BlendEnable = true;
	AlphaTest = false;
	SourceBlend = "src_alpha";
	DestBlend = "inv_src_alpha";
}
Defines = { } -- Comma separated defines ie. "USE_SIMPLE_LIGHTS", "GUI"

DeclareShared( [[

CONSTANT_BUFFER( 2, 48 )
{
	float3 vTime_HalfPixelOffset;
};

]] )

DeclareVertex( [[
struct VS_INPUT_WATER
{
    float2 position			: POSITION;
};
]] )

DeclareVertex( [[
struct VS_OUTPUT_WATER
{
    float4 position			: POSITION;
	float3 pos				: TEXCOORD0;
	float2 uv				: TEXCOORD1;
	float4 screen_pos		: TEXCOORD2;
	float3 cubeRotation     : TEXCOORD3;
	float2 uv_ice			: TEXCOORD4;
};
]] )

water = {
	VertexShader = "VertexShader";
	PixelShader = "PixelShader";
	ShaderModel = 3;	
}

water_color = {
	VertexShader = "VertexShader";
	PixelShader = "PixelShaderColor";
	ShaderModel = 3;
}

DeclareShader( "VertexShader", [[
VS_OUTPUT_WATER main( const VS_INPUT_WATER VertexIn )
{
	VS_OUTPUT_WATER VertexOut;
	VertexOut.pos = float3( VertexIn.position.x, WATER_HEIGHT, VertexIn.position.y );
	VertexOut.position = mul( float4( VertexOut.pos.x, VertexOut.pos.y, VertexOut.pos.z, 1.0f ), ViewProjectionMatrix );
	VertexOut.screen_pos = VertexOut.position;
	VertexOut.screen_pos.y = FIX_FLIPPED_UV( VertexOut.screen_pos.y );
	VertexOut.uv = float2( ( VertexIn.position.x + 0.5f ) / vMapSize.x,  ( VertexIn.position.y + 0.5f - vMapSize.y ) / -vMapSize.y );
	
	VertexOut.uv_ice = VertexOut.uv * float2( MAP_SIZE_X, MAP_SIZE_Y ) * 0.1f;
	VertexOut.uv_ice *= float2( FOW_POW2_X, FOW_POW2_Y ); //POW2
	VertexOut.cubeRotation =  float3(0.0f, 0.0f, 0.0f) ;
	return VertexOut;
}


]] )

DeclareShader( "PixelShader", [[
float4 main( VS_OUTPUT_WATER Input ) : COLOR
{
	return float4( 0.192f, 0.251f, 0.33f, 0.75f);
}

]] )

DeclareShader( "PixelShaderColor", [[
float4 main( VS_OUTPUT_WATER Input ) : COLOR
{

	return float4( 0.192f, 0.251f, 0.33f, 0.75f);
}

]] )
