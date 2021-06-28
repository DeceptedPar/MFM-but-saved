package;

import openfl.ui.KeyLocation;
import openfl.events.Event;
import haxe.EnumTools;
import openfl.ui.Keyboard;
import openfl.events.KeyboardEvent;
import Replay.Ana;
import Replay.Analysis;
#if cpp
import webm.WebmPlayer;
#end
import flixel.input.keyboard.FlxKey;
import haxe.Exception;
import openfl.geom.Matrix;
import openfl.display.BitmapData;
import openfl.utils.AssetType;
import lime.graphics.Image;
import flixel.graphics.FlxGraphic;
import openfl.utils.AssetManifest;
import openfl.utils.AssetLibrary;
import flixel.system.FlxAssets;

import lime.app.Application;
import lime.media.AudioContext;
import lime.media.AudioManager;
import openfl.Lib;
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;

#if windows
import Discord.DiscordClient;
#end
#if windows
import Sys;
import sys.FileSystem;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	public static var instance:PlayState = null;

	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var weekSong:Int = 0;
	public static var weekScore:Int = 0;
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;

	public static var songPosBG:FlxSprite;
	public static var songPosBar:FlxBar;

	public static var rep:Replay;
	public static var loadRep:Bool = false;

	public static var noteBools:Array<Bool> = [false, false, false, false];

	var halloweenLevel:Bool = false;

	var songLength:Float = 0;
	var kadeEngineWatermark:FlxText;
	
	#if windows
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	private var vocals:FlxSound;

	public var originalX:Float;

	public static var dad:Character;
	public static var gf:Character;
	public static var boyfriend:Boyfriend;

	public var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	public var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	public static var strumLineNotes:FlxTypedGroup<FlxSprite> = null;
	public static var playerStrums:FlxTypedGroup<FlxSprite> = null;
	public static var cpuStrums:FlxTypedGroup<FlxSprite> = null;

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	public var health:Float = 1; //making public because sethealth doesnt work without it
	private var combo:Int = 0;
	public static var misses:Int = 0;
	public static var campaignMisses:Int = 0;
	public var accuracy:Float = 0.00;
	private var accuracyDefault:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var totalNotesHitDefault:Float = 0;
	private var totalPlayed:Int = 0;
	private var ss:Bool = false;


	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;
	private var songPositionBar:Float = 0;
	
	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	public var iconP1:HealthIcon; //making these public again because i may be stupid
	public var iconP2:HealthIcon; //what could go wrong?
	public var camHUD:FlxCamera;
	private var camGame:FlxCamera;

	public static var offsetTesting:Bool = false;

	var notesHitArray:Array<Date> = [];
	var currentFrames:Int = 0;

	public var dialogue:Array<String> = ['dad:blah blah blah', 'bf:coolswag'];

	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;
	var songName:FlxText;
	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;

	var tank0:FlxSprite;
	var tank1:FlxSprite;
	var tank2:FlxSprite;
	var tank3:FlxSprite;
	var tank4:FlxSprite;
	var tank5:FlxSprite;
	var tankRolling:FlxSprite;
	var tankX:Int = 400;
	var tankSpeed:Float = FlxG.random.float(5, 7);
	var tankAngle:Float = FlxG.random.float(-90, 45);
	var tankWatchtower:FlxSprite;
	var tankmanRun:FlxTypedGroup<TankmenBG>;

	var fc:Bool = true;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;
	public var songScore:Int = 0;
	var songScoreDef:Int = 0;
	var scoreTxt:FlxText;
	var replayTxt:FlxText;

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

	public static var daPixelZoom:Float = 6;

	public static var theFunne:Bool = true;
	var funneEffect:FlxSprite;
	var inCutscene:Bool = false;
	public static var repPresses:Int = 0;
	public static var repReleases:Int = 0;

	public static var timeCurrently:Float = 0;
	public static var timeCurrentlyR:Float = 0;
	
	// Will fire once to prevent debug spam messages and broken animations
	private var triggeredAlready:Bool = false;
	
	// Will decide if she's even allowed to headbang at all depending on the song
	private var allowedToHeadbang:Bool = false;
	// Per song additive offset
	public static var songOffset:Float = 0;
	// BotPlay text
	private var botPlayState:FlxText;
	// Replay shit
	private var saveNotes:Array<Dynamic> = [];
	private var saveJudge:Array<String> = [];
	private var replayAna:Analysis = new Analysis(); // replay analysis

	public static var highestCombo:Int = 0;

	private var executeModchart = false;

	// API stuff
	
	public function addObject(object:FlxBasic) { add(object); }
	public function removeObject(object:FlxBasic) { remove(object); }


	override public function create()
	{
		instance = this;
		
		if (FlxG.save.data.fpsCap > 290)
			(cast (Lib.current.getChildAt(0), Main)).setFPSCap(800);
		
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		if (!isStoryMode)
		{
			sicks = 0;
			bads = 0;
			shits = 0;
			goods = 0;
		}
		misses = 0;

		repPresses = 0;
		repReleases = 0;


		PlayStateChangeables.useDownscroll = FlxG.save.data.downscroll;
		PlayStateChangeables.safeFrames = FlxG.save.data.frames;
		PlayStateChangeables.scrollSpeed = FlxG.save.data.scrollSpeed;
		PlayStateChangeables.botPlay = FlxG.save.data.botplay;
		PlayStateChangeables.Optimize = FlxG.save.data.optimize;

		// pre lowercasing the song name (create)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
		switch (songLowercase) {
			case 'dad-battle': songLowercase = 'dadbattle';
			case 'philly-nice': songLowercase = 'philly';
			case 'satin-panties': songLowercase = 'satin panties';
			case 'church-lords': songLowercase = 'church lords';
			case 'gospel-remix': songLowercase = 'gospel remix';
			case 'it\'s-been-so-long': songLowercase = 'it\'s been so long';
			case 'panic-stricken': songLowercase = 'panic stricken';
			case 'ruv-jug': songLowercase = 'ruv jug';
			case 'ruvved-up': songLowercase = 'ruvved up';
			case 'too-clergy': songLowercase = 'too clergy';
			case 'tutorial-remix': songLowercase = 'tutorial remix';
			case 'zavodila-remix': songLowercase = 'zavodila remix';
		}
		
		removedVideo = false;

		#if windows
		executeModchart = FileSystem.exists(Paths.lua(songLowercase  + "/modchart"));
		if (executeModchart)
			PlayStateChangeables.Optimize = false;
		#end
		#if !cpp
		executeModchart = false; // FORCE disable for non cpp targets
		#end

		trace('Mod chart: ' + executeModchart + " - " + Paths.lua(songLowercase + "/modchart"));

		#if windows
		// Making difficulty text for Discord Rich Presence.
		storyDifficultyText = CoolUtil.difficultyFromInt(storyDifficulty);

		iconRPC = SONG.player2;

		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'senpai-angry':
				iconRPC = 'senpai';
			case 'monster-christmas':
				iconRPC = 'monster';
			case 'mom-car':
				iconRPC = 'mom';
			case 'sarvente-dark':
				iconRPC = 'sarvente';
			case 'bf-dark':
				iconRPC = 'bf';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: Week " + storyWeek;
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;

		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end


		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);

		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial', 'tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		trace('INFORMATION ABOUT WHAT U PLAYIN WIT:\nFRAMES: ' + PlayStateChangeables.safeFrames + '\nZONE: ' + Conductor.safeZoneOffset + '\nTS: ' + Conductor.timeScale + '\nBotPlay : ' + PlayStateChangeables.botPlay);
	
		//dialogue shit
		switch (songLowercase)
		{
			case 'tutorial':
				dialogue = ["Hey you're pretty cute.", 'Use the arrow keys to keep up \nwith me singing.'];
			case 'bopeebo':
				dialogue = [
					'HEY!',
					"You think you can just sing\nwith my daughter like that?",
					"If you want to date her...",
					"You're going to have to go \nthrough ME first!"
				];
			case 'fresh':
				dialogue = ["Not too bad shabby boy.", ""];
			case 'dadbattle':
				dialogue = [
					"gah you think you're hot stuff?",
					"If you can beat me here...",
					"Only then I will even CONSIDER letting you\ndate my daughter!"
				];
			case 'senpai':
				dialogue = CoolUtil.coolTextFile(Paths.txt('senpai/senpaiDialogue'));
			case 'roses':
				dialogue = CoolUtil.coolTextFile(Paths.txt('roses/rosesDialogue'));
			case 'thorns':
				dialogue = CoolUtil.coolTextFile(Paths.txt('thorns/thornsDialogue'));
			case 'tutorial remix':
				//dialogue = CoolUtil.coolTextFile(Paths.txt('tutorial-remix/Tutorial RemixDialogue'));
			case 'parish':
				//dialogue = CoolUtil.coolTextFile(Paths.txt('parish/ParishDialogue1'));
				//dialogue = CoolUtil.coolTextFile(Paths.txt('parish/ParishDialogue2'));
				dialogue = CoolUtil.coolTextFile(Paths.txt('parish/ParishDialogue3'));
			case 'worship':
				dialogue = CoolUtil.coolTextFile(Paths.txt('worship/WorshipDialogue'));
			case 'zavodila':
				//dialogue = CoolUtil.coolTextFile(Paths.txt('zavodila/ZavodilaDialogue1'));
				dialogue = CoolUtil.coolTextFile(Paths.txt('zavodila/ZavodilaDialogue2'));
			//case 'gospel':
				//dialogue = CoolUtil.coolTextFile(Paths.txt('gospel/GospelDialogue1'));
				//dialogue = CoolUtil.coolTextFile(Paths.txt('gospel/GospelDialogue2'));
			case 'casanova':
				//dialogue = CoolUtil.coolTextFile(Paths.txt('casanova/CasanovaDialogue1'));
				dialogue = CoolUtil.coolTextFile(Paths.txt('casanova/CasanovaDialogue2'));
				//dialogue = CoolUtil.coolTextFile(Paths.txt('casanova/CasanovaDialogue3'));
				//dialogue = CoolUtil.coolTextFile(Paths.txt('casanova/CasanovaDialogue4'));
		}

		//defaults if no stage was found in chart
		var stageCheck:String = 'stage';
		
		if (SONG.stage == null) {
			switch(storyWeek)
			{
				case 2: stageCheck = 'halloween';
				case 3: stageCheck = 'philly';
				case 4: stageCheck = 'limo';
				case 5: if (songLowercase == 'winter-horrorland') {stageCheck = 'mallEvil';} else {stageCheck = 'mall';}
				case 6: if (songLowercase == 'thorns') {stageCheck = 'schoolEvil';} else {stageCheck = 'school';}
				case 7: stageCheck = 'tank';
				//i should check if its stage (but this is when none is found in chart anyway)
			}
		} else {stageCheck = SONG.stage;}

		if (!PlayStateChangeables.Optimize)
		{

		switch(stageCheck)
		{
			case 'halloween': 
			{
				curStage = 'spooky';
				halloweenLevel = true;

				var hallowTex = Paths.getSparrowAtlas('halloween_bg','week2');

				halloweenBG = new FlxSprite(-200, -100);
				halloweenBG.frames = hallowTex;
				halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
				halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
				halloweenBG.animation.play('idle');
				halloweenBG.antialiasing = true;
				add(halloweenBG);

				isHalloween = true;
			}
			case 'philly': 
					{
					curStage = 'philly';

					var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('philly/sky', 'week3'));
					bg.scrollFactor.set(0.1, 0.1);
					add(bg);

					var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('philly/city', 'week3'));
					city.scrollFactor.set(0.3, 0.3);
					city.setGraphicSize(Std.int(city.width * 0.85));
					city.updateHitbox();
					add(city);

					phillyCityLights = new FlxTypedGroup<FlxSprite>();
					if(FlxG.save.data.distractions){
						add(phillyCityLights);
					}

					for (i in 0...5)
					{
							var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('philly/win' + i, 'week3'));
							light.scrollFactor.set(0.3, 0.3);
							light.visible = false;
							light.setGraphicSize(Std.int(light.width * 0.85));
							light.updateHitbox();
							light.antialiasing = true;
							phillyCityLights.add(light);
					}

					var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('philly/behindTrain','week3'));
					add(streetBehind);

					phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('philly/train','week3'));
					if(FlxG.save.data.distractions){
						add(phillyTrain);
					}

					trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes','week3'));
					FlxG.sound.list.add(trainSound);

					// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

					var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('philly/street','week3'));
					add(street);
			}
			case 'limo':
			{
					curStage = 'limo';
					defaultCamZoom = 0.90;

					var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('limo/limoSunset','week4'));
					skyBG.scrollFactor.set(0.1, 0.1);
					add(skyBG);

					var bgLimo:FlxSprite = new FlxSprite(-200, 480);
					bgLimo.frames = Paths.getSparrowAtlas('limo/bgLimo','week4');
					bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
					bgLimo.animation.play('drive');
					bgLimo.scrollFactor.set(0.4, 0.4);
					add(bgLimo);
					if(FlxG.save.data.distractions){
						grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
						add(grpLimoDancers);
	
						for (i in 0...5)
						{
								var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
								dancer.scrollFactor.set(0.4, 0.4);
								grpLimoDancers.add(dancer);
						}
					}

					var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(Paths.image('limo/limoOverlay','week4'));
					overlayShit.alpha = 0.5;
					// add(overlayShit);

					// var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

					// FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

					// overlayShit.shader = shaderBullshit;

					var limoTex = Paths.getSparrowAtlas('limo/limoDrive','week4');

					limo = new FlxSprite(-120, 550);
					limo.frames = limoTex;
					limo.animation.addByPrefix('drive', "Limo stage", 24);
					limo.animation.play('drive');
					limo.antialiasing = true;

					fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('limo/fastCarLol','week4'));
					// add(limo);
			}
			case 'mall':
			{
					curStage = 'mall';

					defaultCamZoom = 0.80;

					var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('christmas/bgWalls','week5'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.2, 0.2);
					bg.active = false;
					bg.setGraphicSize(Std.int(bg.width * 0.8));
					bg.updateHitbox();
					add(bg);

					upperBoppers = new FlxSprite(-240, -90);
					upperBoppers.frames = Paths.getSparrowAtlas('christmas/upperBop','week5');
					upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
					upperBoppers.antialiasing = true;
					upperBoppers.scrollFactor.set(0.33, 0.33);
					upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
					upperBoppers.updateHitbox();
					if(FlxG.save.data.distractions){
						add(upperBoppers);
					}


					var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('christmas/bgEscalator','week5'));
					bgEscalator.antialiasing = true;
					bgEscalator.scrollFactor.set(0.3, 0.3);
					bgEscalator.active = false;
					bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
					bgEscalator.updateHitbox();
					add(bgEscalator);

					var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('christmas/christmasTree','week5'));
					tree.antialiasing = true;
					tree.scrollFactor.set(0.40, 0.40);
					add(tree);

					bottomBoppers = new FlxSprite(-300, 140);
					bottomBoppers.frames = Paths.getSparrowAtlas('christmas/bottomBop','week5');
					bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
					bottomBoppers.antialiasing = true;
					bottomBoppers.scrollFactor.set(0.9, 0.9);
					bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
					bottomBoppers.updateHitbox();
					if(FlxG.save.data.distractions){
						add(bottomBoppers);
					}


					var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('christmas/fgSnow','week5'));
					fgSnow.active = false;
					fgSnow.antialiasing = true;
					add(fgSnow);

					santa = new FlxSprite(-840, 150);
					santa.frames = Paths.getSparrowAtlas('christmas/santa','week5');
					santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
					santa.antialiasing = true;
					if(FlxG.save.data.distractions){
						add(santa);
					}
			}
			case 'mallEvil':
			{
					curStage = 'mallEvil';
					var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('christmas/evilBG','week5'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.2, 0.2);
					bg.active = false;
					bg.setGraphicSize(Std.int(bg.width * 0.8));
					bg.updateHitbox();
					add(bg);

					var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('christmas/evilTree','week5'));
					evilTree.antialiasing = true;
					evilTree.scrollFactor.set(0.2, 0.2);
					add(evilTree);

					var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("christmas/evilSnow",'week5'));
						evilSnow.antialiasing = true;
					add(evilSnow);
					}
			case 'school':
			{
					curStage = 'school';

					// defaultCamZoom = 0.9;

					var bgSky = new FlxSprite().loadGraphic(Paths.image('weeb/weebSky','week6'));
					bgSky.scrollFactor.set(0.1, 0.1);
					add(bgSky);

					var repositionShit = -200;

					var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/weebSchool','week6'));
					bgSchool.scrollFactor.set(0.6, 0.90);
					add(bgSchool);

					var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/weebStreet','week6'));
					bgStreet.scrollFactor.set(0.95, 0.95);
					add(bgStreet);

					var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('weeb/weebTreesBack','week6'));
					fgTrees.scrollFactor.set(0.9, 0.9);
					add(fgTrees);

					var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
					var treetex = Paths.getPackerAtlas('weeb/weebTrees','week6');
					bgTrees.frames = treetex;
					bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
					bgTrees.animation.play('treeLoop');
					bgTrees.scrollFactor.set(0.85, 0.85);
					add(bgTrees);

					var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
					treeLeaves.frames = Paths.getSparrowAtlas('weeb/petals','week6');
					treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
					treeLeaves.animation.play('leaves');
					treeLeaves.scrollFactor.set(0.85, 0.85);
					add(treeLeaves);

					var widShit = Std.int(bgSky.width * 6);

					bgSky.setGraphicSize(widShit);
					bgSchool.setGraphicSize(widShit);
					bgStreet.setGraphicSize(widShit);
					bgTrees.setGraphicSize(Std.int(widShit * 1.4));
					fgTrees.setGraphicSize(Std.int(widShit * 0.8));
					treeLeaves.setGraphicSize(widShit);

					fgTrees.updateHitbox();
					bgSky.updateHitbox();
					bgSchool.updateHitbox();
					bgStreet.updateHitbox();
					bgTrees.updateHitbox();
					treeLeaves.updateHitbox();

					bgGirls = new BackgroundGirls(-100, 190);
					bgGirls.scrollFactor.set(0.9, 0.9);

					if (songLowercase == 'roses')
						{
							if(FlxG.save.data.distractions){
								bgGirls.getScared();
							}
						}

					bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
					bgGirls.updateHitbox();
					if(FlxG.save.data.distractions){
						add(bgGirls);
					}
			}
			case 'schoolEvil':
			{
					curStage = 'schoolEvil';

					var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
					var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);

					var posX = 400;
					var posY = 200;

					var bg:FlxSprite = new FlxSprite(posX, posY);
					bg.frames = Paths.getSparrowAtlas('weeb/animatedEvilSchool','week6');
					bg.animation.addByPrefix('idle', 'background 2', 24);
					bg.animation.play('idle');
					bg.scrollFactor.set(0.8, 0.9);
					bg.scale.set(6, 6);
					add(bg);

					/* 
							var bg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolBG'));
							bg.scale.set(6, 6);
							// bg.setGraphicSize(Std.int(bg.width * 6));
							// bg.updateHitbox();
							add(bg);
							var fg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolFG'));
							fg.scale.set(6, 6);
							// fg.setGraphicSize(Std.int(fg.width * 6));
							// fg.updateHitbox();
							add(fg);
							wiggleShit.effectType = WiggleEffectType.DREAMY;
							wiggleShit.waveAmplitude = 0.01;
							wiggleShit.waveFrequency = 60;
							wiggleShit.waveSpeed = 0.8;
						*/

					// bg.shader = wiggleShit.shader;
					// fg.shader = wiggleShit.shader;

					/* 
								var waveSprite = new FlxEffectSprite(bg, [waveEffectBG]);
								var waveSpriteFG = new FlxEffectSprite(fg, [waveEffectFG]);
								// Using scale since setGraphicSize() doesnt work???
								waveSprite.scale.set(6, 6);
								waveSpriteFG.scale.set(6, 6);
								waveSprite.setPosition(posX, posY);
								waveSpriteFG.setPosition(posX, posY);
								waveSprite.scrollFactor.set(0.7, 0.8);
								waveSpriteFG.scrollFactor.set(0.9, 0.8);
								// waveSprite.setGraphicSize(Std.int(waveSprite.width * 6));
								// waveSprite.updateHitbox();
								// waveSpriteFG.setGraphicSize(Std.int(fg.width * 6));
								// waveSpriteFG.updateHitbox();
								add(waveSprite);
								add(waveSpriteFG);
						*/
			}
			case 'tank':
				{
						defaultCamZoom = 0.9;
						curStage = 'tank';

						var tankSky:FlxSprite = new FlxSprite(-400, -400).loadGraphic(Paths.image('tank/tankSky', 'week7'));
						tankSky.antialiasing = true;
						tankSky.scrollFactor.set(0, 0);
						add(tankSky);

						var tankClouds:FlxSprite = new FlxSprite(-700, -100).loadGraphic(Paths.image('tank/tankClouds', 'week7'));
						tankClouds.scrollFactor.set(0.1, 0.1);
						tankClouds.velocity.x = FlxG.random.float(5, 15);
						tankClouds.antialiasing = true;
						tankClouds.updateHitbox();
						add(tankClouds);

						var tankMountains:FlxSprite = new FlxSprite(-300, -20).loadGraphic(Paths.image('tank/tankMountains', 'week7'));
						tankMountains.antialiasing = true;
						tankMountains.setGraphicSize(Std.int(tankMountains.width * 1.2));
						tankMountains.scrollFactor.set(0.2, 0.2);
						tankMountains.updateHitbox();
						add(tankMountains);

						var tankBuildings:FlxSprite = new FlxSprite(-200, 0).loadGraphic(Paths.image('tank/tankBuildings', 'week7'));
						tankBuildings.antialiasing = true;
						tankBuildings.setGraphicSize(Std.int(tankBuildings.width * 1.1));
						tankBuildings.scrollFactor.set(0.3, 0.3);
						tankBuildings.updateHitbox();
						add(tankBuildings);

						var tankRuins:FlxSprite = new FlxSprite(-200, 0).loadGraphic(Paths.image('tank/tankRuins', 'week7'));
						tankRuins.antialiasing = true;
						tankRuins.setGraphicSize(Std.int(tankRuins.width * 1.1));
						tankRuins.scrollFactor.set(0.35, 0.35);
						tankRuins.updateHitbox();
						add(tankRuins);

						var smokeLeft:FlxSprite = new FlxSprite(-200, -100).loadGraphic(Paths.image('tank/smokeLeft', 'week7'));
						smokeLeft.frames = Paths.getSparrowAtlas('tank/smokeLeft');
						smokeLeft.animation.addByPrefix('idle', 'SmokeBlurLeft', 24, true);
						smokeLeft.animation.play('idle');
						smokeLeft.scrollFactor.set (0.4, 0.4);
						smokeLeft.antialiasing = true;
						add(smokeLeft);

						var smokeRight:FlxSprite = new FlxSprite(1100, -100).loadGraphic(Paths.image('tank/smokeRight', 'week7'));
						smokeRight.frames = Paths.getSparrowAtlas('tank/smokeRight');
						smokeRight.animation.addByPrefix('idle', 'SmokeRight', 24, true);
						smokeRight.animation.play('idle');
						smokeRight.scrollFactor.set (0.4, 0.4);
						smokeRight.antialiasing = true;
						add(smokeRight);

						tankWatchtower = new TankWatchtower(100, 30);
						tankWatchtower.frames = Paths.getSparrowAtlas('tank/tankWatchtower', 'week7');
						tankWatchtower.animation.addByPrefix('idle', 'watchtower gradient color instance 1', 24, false);
						tankWatchtower.scrollFactor.set(0.5, 0.5);
						tankWatchtower.antialiasing = true;
						add(tankWatchtower);

						var tankRolling:FlxSprite = new FlxSprite(300, 300).loadGraphic(Paths.image('tank/tankRolling', 'week7'));
						tankRolling.frames = Paths.getSparrowAtlas('tank/tankRolling');
						tankRolling.animation.addByPrefix('idle', 'BG tank w lighting', 24, true);
						tankRolling.antialiasing = true;
						tankRolling.scrollFactor.set(0.5, 0.5);
						add(tankRolling);

						var tankGround:FlxSprite = new FlxSprite(-420, -150).loadGraphic(Paths.image('tank/tankGround', 'week7'));
						tankGround.scrollFactor.set(1, 1);
						tankGround.setGraphicSize(Std.int(tankGround.width * 1.15));
						tankGround.updateHitbox();
						tankGround.antialiasing = true;
						add(tankGround);

						moveTank();

						tank0 = new FlxSprite(-500, 650);
						tank0.frames = Paths.getSparrowAtlas('tank/tank0', 'week7');
						tank0.animation.addByPrefix('idle', 'fg tankhead far right', 24, false);
						tank0.scrollFactor.set(1.7, 1.5);
						tank0.antialiasing = true;
						tank0.updateHitbox();

						tank1 = new FlxSprite(-300, 750);
						tank1.frames = Paths.getSparrowAtlas('tank/tank1', 'week7');
						tank1.animation.addByPrefix('idle', 'fg', 24, false);
						tank1.scrollFactor.set(2, 0.2);
						tank1.antialiasing = true;
						tank1.updateHitbox();

						tank2 = new FlxSprite(450, 940);
						tank2.frames = Paths.getSparrowAtlas('tank/tank2', 'week7');
						tank2.animation.addByPrefix('idle', 'foreground', 24, false);
						tank2.scrollFactor.set(1.5, 1.5);
						tank2.antialiasing = true;
						tank2.updateHitbox();

						tank4 = new FlxSprite(1300, 900);
						tank4.frames = Paths.getSparrowAtlas('tank/tank4', 'week7');
						tank4.animation.addByPrefix('idle', 'fg', 24, false);
						tank4.scrollFactor.set(1.5, 1.5);
						tank4.antialiasing = true;
						tank4.updateHitbox();

						tank5 = new FlxSprite(1620, 700);
						tank5.frames = Paths.getSparrowAtlas('tank/tank5', 'week7');
						tank5.animation.addByPrefix('idle', 'fg', 24, false);
						tank5.scrollFactor.set(1.5, 1.5);
						tank5.antialiasing = true;
						tank5.updateHitbox();

						tank3 = new FlxSprite(1300, 1200);
						tank3.frames = Paths.getSparrowAtlas('tank/tank3', 'week7');
						tank3.animation.addByPrefix('idle', 'fg', 24, false);
						tank3.scrollFactor.set(1.5, 1.5);
						tank3.antialiasing = true;
						tank3.updateHitbox();

				}
			case 'church1':
				{
						defaultCamZoom = 0.9;
						curStage = 'church1';
						var stageFront:FlxSprite = new FlxSprite(286, -160).loadGraphic(Paths.image('sacredmass/church1/floor'));
						stageFront.updateHitbox();
						stageFront.antialiasing = true;
						stageFront.active = false;
						add(stageFront);

						var bg:FlxSprite = new FlxSprite(286, -160).loadGraphic(Paths.image('sacredmass/church1/bg'));
						bg.antialiasing = true;
						bg.active = false;
						add(bg);

						var stageCurtains:FlxSprite = new FlxSprite(286, -160).loadGraphic(Paths.image('sacredmass/church1/pillars'));
						stageCurtains.updateHitbox();
						stageCurtains.antialiasing = true;
						stageCurtains.active = false;

						add(stageCurtains);
				}
			case 'church1-dark':
				{
						defaultCamZoom = 0.9;
						curStage = 'church1-dark';
						var stageFront:FlxSprite = new FlxSprite(286, -160).loadGraphic(Paths.image('sacredmass/church1/floor-dark'));
						stageFront.updateHitbox();
						stageFront.antialiasing = true;
						stageFront.active = false;
						add(stageFront);

						var bg:FlxSprite = new FlxSprite(286, -160).loadGraphic(Paths.image('sacredmass/church1/bg-dark'));
						bg.antialiasing = true;
						bg.active = false;
						add(bg);

						var stageCurtains:FlxSprite = new FlxSprite(286, -160).loadGraphic(Paths.image('sacredmass/church1/pillars-dark'));
						stageCurtains.updateHitbox();
						stageCurtains.antialiasing = true;
						stageCurtains.active = false;

						add(stageCurtains);
				}
			case 'church2':
				{
						defaultCamZoom = 0.9;
						curStage = 'church2';
						var stageFront:FlxSprite = new FlxSprite(286, -160).loadGraphic(Paths.image('sacredmass/church2/floor'));
						stageFront.updateHitbox();
						stageFront.antialiasing = true;
						stageFront.active = false;
						add(stageFront);

						var bg:FlxSprite = new FlxSprite(286, -160).loadGraphic(Paths.image('sacredmass/church2/bg'));
						bg.antialiasing = true;
						bg.active = false;
						add(bg);

						var stageCurtains:FlxSprite = new FlxSprite(286, -160).loadGraphic(Paths.image('sacredmass/church2/pillars'));
						stageCurtains.updateHitbox();
						stageCurtains.antialiasing = true;
						stageCurtains.active = false;

						add(stageCurtains);

						var stageCurtains:FlxSprite = new FlxSprite(286, -160).loadGraphic(Paths.image('sacredmass/church2/pillarbroke'));
						stageCurtains.updateHitbox();
						stageCurtains.antialiasing = true;
						stageCurtains.active = false;

						add(stageCurtains);
				}
			case 'church3':
				{
						defaultCamZoom = 0.9;
						curStage = 'church3';
						var stageFront:FlxSprite = new FlxSprite(286, -160).loadGraphic(Paths.image('sacredmass/church3/floor'));
						stageFront.updateHitbox();
						stageFront.antialiasing = true;
						stageFront.active = false;
						add(stageFront);

						var bg:FlxSprite = new FlxSprite(286, -160).loadGraphic(Paths.image('sacredmass/church3/bg'));
						bg.antialiasing = true;
						bg.active = false;
						add(bg);

						var stageCurtains:FlxSprite = new FlxSprite(286, -160).loadGraphic(Paths.image('sacredmass/church3/pillars'));
						stageCurtains.updateHitbox();
						stageCurtains.antialiasing = true;
						stageCurtains.active = false;

						add(stageCurtains);

						var stageCurtains:FlxSprite = new FlxSprite(286, -160).loadGraphic(Paths.image('sacredmass/church3/circ0'));
						stageCurtains.updateHitbox();
						stageCurtains.antialiasing = true;
						stageCurtains.active = false;

						add(stageCurtains);

						var stageCurtains = new FlxSprite(935, 171).loadGraphic(Paths.image('sacredmass/church3/circ1'));
						stageCurtains.antialiasing = true;

						FlxTween.angle(stageCurtains, stageCurtains.angle, 7200, 360, {type: FlxTween.LOOPING, ease: FlxEase.sineIn});

						add(stageCurtains);

						var stageCurtains:FlxSprite = new FlxSprite(900, 132).loadGraphic(Paths.image('sacredmass/church3/circ2'));
						stageCurtains.updateHitbox();
						stageCurtains.antialiasing = true;
						stageCurtains.active = false;

						add(stageCurtains);
				}
			case 'church3ruv':
				{
						defaultCamZoom = 0.9;
						curStage = 'church3ruv';
						var stageFront:FlxSprite = new FlxSprite(286, -160).loadGraphic(Paths.image('sacredmass/church3ruv/floor'));
						stageFront.updateHitbox();
						stageFront.antialiasing = true;
						stageFront.active = false;
						add(stageFront);

						var bg:FlxSprite = new FlxSprite(286, -160).loadGraphic(Paths.image('sacredmass/church3ruv/bg'));
						bg.antialiasing = true;
						bg.active = false;
						add(bg);

						var stageCurtains:FlxSprite = new FlxSprite(286, -160).loadGraphic(Paths.image('sacredmass/church3ruv/pillars'));
						stageCurtains.updateHitbox();
						stageCurtains.antialiasing = true;
						stageCurtains.active = false;

						add(stageCurtains);

						var stageCurtains:FlxSprite = new FlxSprite(286, -160).loadGraphic(Paths.image('sacredmass/church3ruv/circ0'));
						stageCurtains.updateHitbox();
						stageCurtains.antialiasing = true;
						stageCurtains.active = false;

						add(stageCurtains);

						var stageCurtains = new FlxSprite(935, 171).loadGraphic(Paths.image('sacredmass/church3ruv/circ1'));
						stageCurtains.antialiasing = true;

						FlxTween.angle(stageCurtains, stageCurtains.angle, 7200, 360, {type: FlxTween.LOOPING, ease: FlxEase.sineIn});

						add(stageCurtains);

						var stageCurtains:FlxSprite = new FlxSprite(900, 132).loadGraphic(Paths.image('sacredmass/church3ruv/circ2'));
						stageCurtains.updateHitbox();
						stageCurtains.antialiasing = true;
						stageCurtains.active = false;

						add(stageCurtains);
				}
			case 'churchSelever':
				{
						defaultCamZoom = 0.9;
						curStage = 'churchSelever';
						var stageFront:FlxSprite = new FlxSprite(286, -160).loadGraphic(Paths.image('sacredmass/churchSelever/floor'));
						stageFront.updateHitbox();
						stageFront.antialiasing = true;
						stageFront.active = false;
						add(stageFront);

						var bg:FlxSprite = new FlxSprite(286, -160).loadGraphic(Paths.image('sacredmass/churchSelever/bg'));
						bg.antialiasing = true;
						bg.active = false;
						add(bg);

						var stageCurtains:FlxSprite = new FlxSprite(286, -160).loadGraphic(Paths.image('sacredmass/churchSelever/pillars'));
						stageCurtains.updateHitbox();
						stageCurtains.antialiasing = true;
						stageCurtains.active = false;

						add(stageCurtains);
				}
			case 'church0':
				{
						defaultCamZoom = 0.9;
						curStage = 'church0';
						var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('sacredmass/church0/stageback'));
						bg.antialiasing = true;
						bg.scrollFactor.set(0.9, 0.9);
						bg.active = false;
						add(bg);

						var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('sacredmass/church0/stagefront'));
						stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
						stageFront.updateHitbox();
						stageFront.antialiasing = true;
						stageFront.scrollFactor.set(0.9, 0.9);
						stageFront.active = false;
						add(stageFront);
				}
			case 'stage':
				{
						defaultCamZoom = 0.9;
						curStage = 'stage';
						var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
						bg.antialiasing = true;
						bg.scrollFactor.set(0.9, 0.9);
						bg.active = false;
						add(bg);
	
						var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
						stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
						stageFront.updateHitbox();
						stageFront.antialiasing = true;
						stageFront.scrollFactor.set(0.9, 0.9);
						stageFront.active = false;
						add(stageFront);
	
						var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
						stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
						stageCurtains.updateHitbox();
						stageCurtains.antialiasing = true;
						stageCurtains.scrollFactor.set(1.3, 1.3);
						stageCurtains.active = false;
	
						add(stageCurtains);
				}
			default:
			{
					defaultCamZoom = 0.9;
					curStage = 'stage';
					var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.9, 0.9);
					bg.active = false;
					add(bg);

					var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
					stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
					stageFront.updateHitbox();
					stageFront.antialiasing = true;
					stageFront.scrollFactor.set(0.9, 0.9);
					stageFront.active = false;
					add(stageFront);

					var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
					stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
					stageCurtains.updateHitbox();
					stageCurtains.antialiasing = true;
					stageCurtains.scrollFactor.set(1.3, 1.3);
					stageCurtains.active = false;

					add(stageCurtains);
			}
		}
		}
		//defaults if no gf was found in chart
		var gfCheck:String = 'gf';
		
		if (SONG.gfVersion == null) {
			switch(storyWeek)
			{
				case 4: gfCheck = 'gf-car';
				case 5: gfCheck = 'gf-christmas';
				case 6: gfCheck = 'gf-pixel';
				case 7: if (songLowercase == 'stress') {gfCheck = 'pico-speaker';} else {gfCheck = 'gf-tankmen';}
			}
		} else {gfCheck = SONG.gfVersion;}

		var curGf:String = '';
		switch (gfCheck)
		{
			case 'gf-car':
				curGf = 'gf-car';
			case 'gf-christmas':
				curGf = 'gf-christmas';
			case 'gf-pixel':
				curGf = 'gf-pixel';
			case 'un-gf':
				curGf = 'un-gf';
			case 'gf-tankmen':
				curGf = 'gf-tankmen';
			case 'pico-speaker':
				curGf = 'pico-speaker';
			default:
				curGf = 'gf';
		}
		
		gf = new Character(400, 130, curGf);
		gf.scrollFactor.set(0.95, 0.95);

		dad = new Character(100, 100, SONG.player2);

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}

			case "spooky":
				dad.y += 200;
			case "monster":
				dad.y += 100;
			case 'monster-christmas':
				dad.y += 130;
			case 'dad':
				camPos.x += 400;
			case 'pico':
				camPos.x += 600;
				dad.y += 300;
			case 'parents-christmas':
				dad.x -= 500;
			case 'senpai':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'senpai-angry':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'spirit':
				dad.x -= 150;
				dad.y += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'tankman':
				dad.y += 180;
			case 'sarvente':
				dad.x = 630;
				dad.y = 554;
			case 'sarvente-alt':
				dad.x = 630;
				dad.y = 554;
			case 'sarvente-dark':
				dad.x = 630;
				dad.y = 554;
			case 'ruv':
				dad.x = 630;
				dad.y = 554;
			case 'ruv-alt':
				dad.x = 630;
				dad.y = 554;
			case 'luci-sarv':
				dad.x = 630.35;
				dad.y = 323.30;
			case 'selever':
				dad.x = 630;
				dad.y = 554;
		}


		
		boyfriend = new Boyfriend(770, 450, SONG.player1);

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'limo':
				boyfriend.y -= 220;
				boyfriend.x += 260;
				if(FlxG.save.data.distractions){
					resetFastCar();
					add(fastCar);
				}

			case 'mall':
				boyfriend.x += 200;

			case 'mallEvil':
				boyfriend.x += 320;
				dad.y -= 80;
			case 'school':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'schoolEvil':
				if(FlxG.save.data.distractions){
				// trailArea.scrollFactor.set();
				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
				// evilTrail.changeValuesEnabled(false, false, false, false);
				// evilTrail.changeGraphic()
				add(evilTrail);
				// evilTrail.scrollFactor.set(1.1, 1.1);
				}
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;

			case 'tank':
				boyfriend.x += 40;
				gf.x -= 200;
				gf.y += -55;
				dad.x -= 80;
				dad.y += 60;

			case 'church1':
			if (boyfriend.curCharacter == 'bf')
			{
				boyfriend.setPosition(1379, 881);
				gf.setPosition(895, 453);
			}

			if (boyfriend.curCharacter == 'sarvente')
			{
				boyfriend.setPosition(1379, 554);
				gf.setPosition(895, 453);
			}

			if (boyfriend.curCharacter == 'ruv')
			{
				boyfriend.setPosition(1379, 554);
				gf.setPosition(895, 453);
			}

			case 'church1-dark':
			if (boyfriend.curCharacter == 'bf')
			{
				boyfriend.setPosition(1379, 881);
				gf.setPosition(895, 453);
			}

			if (boyfriend.curCharacter == 'sarvente')
			{
				boyfriend.setPosition(1379, 554);
				gf.setPosition(895, 453);
			}

			if (boyfriend.curCharacter == 'ruv')
			{
				boyfriend.setPosition(1379, 554);
				gf.setPosition(895, 453);
			}

			case 'church2':
			if (boyfriend.curCharacter == 'bf')
			{
				boyfriend.setPosition(1379, 881);
				gf.setPosition(895, 453);
			}

			if (boyfriend.curCharacter == 'sarvente')
			{
				boyfriend.setPosition(1379, 554);
				gf.setPosition(895, 453);
			}

			if (boyfriend.curCharacter == 'ruv')
			{
				boyfriend.setPosition(1379, 554);
				gf.setPosition(895, 453);
			}

			case 'church3':
			if (boyfriend.curCharacter == 'bf')
			{
				boyfriend.setPosition(1379, 881);
				gf.setPosition(895, 453);
			}

			if (boyfriend.curCharacter == 'sarvente')
			{
				boyfriend.setPosition(1379, 554);
				gf.setPosition(895, 453);
			}

			if (boyfriend.curCharacter == 'ruv')
			{
				boyfriend.setPosition(1379, 554);
				gf.setPosition(895, 453);
			}

			case 'church3ruv':
			if (boyfriend.curCharacter == 'bf')
			{
				boyfriend.setPosition(1379, 881);
				gf.setPosition(895, 453);
			}

			if (boyfriend.curCharacter == 'sarvente')
			{
				boyfriend.setPosition(1379, 554);
				gf.setPosition(895, 453);
			}

			if (boyfriend.curCharacter == 'ruv')
			{
				boyfriend.setPosition(1379, 554);
				gf.setPosition(895, 453);
			}

			case 'churchSelever':
			if (boyfriend.curCharacter == 'bf')
			{
				boyfriend.setPosition(1379, 881);
				gf.setPosition(895, 453);
			}

			if (boyfriend.curCharacter == 'sarvente')
			{
				boyfriend.setPosition(1379, 554);
				gf.setPosition(895, 453);
			}

			if (boyfriend.curCharacter == 'ruv')
			{
				boyfriend.setPosition(1379, 554);
				gf.setPosition(895, 453);
			}
		}

		if (!PlayStateChangeables.Optimize)
		{
			add(gf);

			// Shitty layering but whatev it works LOL
			if (curStage == 'limo')
				add(limo);

			add(dad);
			add(boyfriend);

			if (curStage == 'tank')
				add(tank0);
				add(tank1);
				add(tank2);
				add(tank4);
				add(tank5);
				add(tank3);
		}


		if (loadRep)
		{
			FlxG.watch.addQuick('rep rpesses',repPresses);
			FlxG.watch.addQuick('rep releases',repReleases);
			// FlxG.watch.addQuick('Queued',inputsQueued);

			PlayStateChangeables.useDownscroll = rep.replay.isDownscroll;
			PlayStateChangeables.safeFrames = rep.replay.sf;
			PlayStateChangeables.botPlay = true;
		}

		trace('uh ' + PlayStateChangeables.safeFrames);

		trace("SF CALC: " + Math.floor((PlayStateChangeables.safeFrames / 60) * 1000));

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;
		
		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();
		
		if (PlayStateChangeables.useDownscroll)
			strumLine.y = FlxG.height - 165;

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<FlxSprite>();
		cpuStrums = new FlxTypedGroup<FlxSprite>();

		// startCountdown();

		if (SONG.song == null)
			trace('song is null???');
		else
			trace('song looks gucci');

		generateSong(SONG.song);

		trace('generated');

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		if (FlxG.save.data.songPosition) // I dont wanna talk about this code :(
			{
				songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
				if (PlayStateChangeables.useDownscroll)
					songPosBG.y = FlxG.height * 0.9 + 45; 
				songPosBG.screenCenter(X);
				songPosBG.scrollFactor.set();
				add(songPosBG);
				
				songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
					'songPositionBar', 0, 90000);
				songPosBar.scrollFactor.set();
				songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
				add(songPosBar);
	
				var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - (SONG.song.length * 5),songPosBG.y,0,SONG.song, 16);
				if (PlayStateChangeables.useDownscroll)
					songName.y -= 3;
				songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
				songName.scrollFactor.set();
				add(songName);
				songName.cameras = [camHUD];
			}

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		if (PlayStateChangeables.useDownscroll)
			healthBarBG.y = 50;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
		// healthBar
		add(healthBar);

		// Add Kade Engine watermark
		kadeEngineWatermark = new FlxText(4,healthBarBG.y + 50,0,SONG.song + " - " + CoolUtil.difficultyFromInt(storyDifficulty) + (Main.watermarks ? " | KE " + MainMenuState.kadeEngineVer : ""), 16);
		kadeEngineWatermark.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		kadeEngineWatermark.scrollFactor.set();
		add(kadeEngineWatermark);

		if (PlayStateChangeables.useDownscroll)
			kadeEngineWatermark.y = FlxG.height * 0.9 + 45;

		scoreTxt = new FlxText(FlxG.width / 2 - 235, healthBarBG.y + 50, 0, "", 20);

		scoreTxt.screenCenter(X);

		originalX = scoreTxt.x;


		scoreTxt.scrollFactor.set();
		
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);

		add(scoreTxt);

		replayTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (PlayStateChangeables.useDownscroll ? 100 : -100), 0, "REPLAY", 20);
		replayTxt.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		replayTxt.borderSize = 4;
		replayTxt.borderQuality = 2;
		replayTxt.scrollFactor.set();
		if (loadRep)
		{
			add(replayTxt);
		}
		// Literally copy-paste of the above, fu
		botPlayState = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (PlayStateChangeables.useDownscroll ? 100 : -100), 0, "BOTPLAY", 20);
		botPlayState.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		botPlayState.scrollFactor.set();
		botPlayState.borderSize = 4;
		botPlayState.borderQuality = 2;
		if(PlayStateChangeables.botPlay && !loadRep) add(botPlayState);

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		doof.cameras = [camHUD];
		if (FlxG.save.data.songPosition)
		{
			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
		}
		kadeEngineWatermark.cameras = [camHUD];
		if (loadRep)
			replayTxt.cameras = [camHUD];

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;
		
		trace('starting');

		if (isStoryMode)
		{
			switch (StringTools.replace(curSong," ", "-").toLowerCase())
			{
				case "winter-horrorland":
					var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						remove(blackScreen);
						FlxG.sound.play(Paths.sound('Lights_Turn_On'));
						camFollow.y = -2050;
						camFollow.x += 200;
						FlxG.camera.focusOn(camFollow.getPosition());
						FlxG.camera.zoom = 1.5;

						new FlxTimer().start(0.8, function(tmr:FlxTimer)
						{
							camHUD.visible = true;
							remove(blackScreen);
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween)
								{
									startCountdown();
								}
							});
						});
					});
				case 'senpai':
					schoolIntro(doof);
				case 'roses':
					FlxG.sound.play(Paths.sound('ANGRY'));
					schoolIntro(doof);
				case 'thorns':
					schoolIntro(doof);
				/*case 'ugh':
					ughAndGunsIntro();
				case 'guns':
					ughAndGunsIntro();
				case 'stress':
					stressIntro();
				case 'tutorial-remix':
					schoolIntro(doof);*/
				case 'parish':
					schoolIntro(doof);
				case 'worship':
					schoolIntro(doof);
				case 'zavodila':
					schoolIntro(doof);
				//case 'gospel':
				//	schoolIntro(doof);
				case 'casanova':
					schoolIntro(doof);
				default:
					startCountdown();
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				case 'tutorial remix':
					dad.dance();
					boyfriend.playAnim('idle');
					generateStaticArrows(0);
					generateStaticArrows(1);
					camHUD.visible = true;
					startSong();

				case 'church lords':
					dad.dance();
					gf.playAnim('dance');
					boyfriend.playAnim('idle');
					generateStaticArrows(0);
					generateStaticArrows(1);
					camHUD.visible = true;
					startSong();
					startCountdown();

				case 'ruv jug':
					dad.dance();
					gf.playAnim('dance');
					boyfriend.playAnim('idle');
					generateStaticArrows(0);
					generateStaticArrows(1);
					camHUD.visible = true;
					startSong();
					startCountdown();

				default:
					startCountdown();
			}
		}

		if (!loadRep)
			rep = new Replay("na");

		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN,handleInput);

		super.create();
	}

	function casanovaIntro(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		camHUD.visible = false;

		if (SONG.song.toLowerCase() == 'parish' || SONG.song.toLowerCase() == 'worship' || SONG.song.toLowerCase() == 'zavodila')
		{
			remove(black);
			
			if(SONG.song.toLowerCase() == 'casanova')
			{
				add(black);
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{

			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{

				if (dialogueBox != null)
				{
					inCutscene = true;
					add(dialogueBox);
				}
				remove(black);
			}
		});
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();

		if (StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase() == 'roses' || StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase() == 'thorns')
		{
			remove(black);

			if (StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase() == 'thorns')
			{
				add(red);
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					inCutscene = true;

					if (StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase() == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	var luaWiggles:Array<WiggleEffect> = [];

	#if windows
	public static var luaModchart:ModchartState = null;
	#end

	function startCountdown():Void
	{
		inCutscene = false;

		generateStaticArrows(0);
		generateStaticArrows(1);


		#if windows
		// pre lowercasing the song name (startCountdown)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
		switch (songLowercase) {
			case 'dad-battle': songLowercase = 'dadbattle';
			case 'philly-nice': songLowercase = 'philly';
			case 'satin-panties': songLowercase = 'satin panties';
			case 'church-lords': songLowercase = 'church lords';
			case 'gospel-remix': songLowercase = 'gospel remix';
			case 'it\'s-been-so-long': songLowercase = 'it\'s been so long';
			case 'panic-stricken': songLowercase = 'panic stricken';
			case 'ruv-jug': songLowercase = 'ruv jug';
			case 'ruvved-up': songLowercase = 'ruvved up';
			case 'too-clergy': songLowercase = 'too clergy';
			case 'tutorial-remix': songLowercase = 'tutorial remix';
			case 'zavodila-remix': songLowercase = 'zavodila remix';
		}
		if (executeModchart)
		{
			luaModchart = ModchartState.createModchartState();
			luaModchart.executeState('start',[songLowercase]);
		}
		#end

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			boyfriend.playAnim('idle');

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);
			introAssets.set('school', [
				'weeb/pixelUI/ready-pixel',
				'weeb/pixelUI/set-pixel',
				'weeb/pixelUI/date-pixel'
			]);
			introAssets.set('schoolEvil', [
				'weeb/pixelUI/ready-pixel',
				'weeb/pixelUI/set-pixel',
				'weeb/pixelUI/date-pixel'
			]);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3' + altSuffix), 0.6);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2' + altSuffix), 0.6);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1' + altSuffix), 0.6);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();

					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introGo' + altSuffix), 0.6);

					if (SONG.song.toLowerCase() == 'casanova' && dad.curCharacter == 'selever')
					{
						dad.playAnim('hey', true);
					}

					if (SONG.song.toLowerCase() == 'tutorial remix' && dad.curCharacter == 'gf')
					{
						dad.playAnim('cheer', true);
					}

				case 4:
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;


	private function getKey(charCode:Int):String
	{
		for (key => value in FlxKey.fromStringMap)
		{
			if (charCode == value)
				return key;
		}
		return null;
	}

	private function handleInput(evt:KeyboardEvent):Void { // this actually handles press inputs

		if (PlayStateChangeables.botPlay || loadRep || paused)
			return;

		// first convert it from openfl to a flixel key code
		// then use FlxKey to get the key's name based off of the FlxKey dictionary
		// this makes it work for special characters

		@:privateAccess
		var key = FlxKey.toStringMap.get(Keyboard.__convertKeyCode(evt.keyCode));
	
		var binds:Array<String> = [FlxG.save.data.leftBind,FlxG.save.data.downBind, FlxG.save.data.upBind, FlxG.save.data.rightBind];

		var data = -1;
		
		switch(evt.keyCode) // arrow keys
		{
			case 37:
				data = 0;
			case 40:
				data = 1;
			case 38:
				data = 2;
			case 39:
				data = 3;
		}

		for (i in 0...binds.length) // binds
		{
			if (binds[i].toLowerCase() == key.toLowerCase())
				data = i;
		}

		if (evt.keyLocation == KeyLocation.NUM_PAD)
		{
			trace(String.fromCharCode(evt.charCode) + " " + key);
		}

		if (data == -1)
			return;

		var ana = new Ana(Conductor.songPosition, null, false, "miss", data);

		var dataNotes = [];
		notes.forEachAlive(function(daNote:Note)
		{
			if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit && daNote.noteData == data)
				dataNotes.push(daNote);
		}); // Collect notes that can be hit


		dataNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime)); // sort by the earliest note
		
		if (dataNotes.length != 0)
		{
			var coolNote = dataNotes[0];

			goodNoteHit(coolNote);
			var noteDiff:Float = -(coolNote.strumTime - Conductor.songPosition);
			ana.hit = true;
			ana.hitJudge = Ratings.CalculateRating(noteDiff, Math.floor((PlayStateChangeables.safeFrames / 60) * 1000));
			ana.nearestNote = [coolNote.strumTime,coolNote.noteData,coolNote.sustainLength];
		}
		
	}

	var songStarted = false;

	function startSong():Void
	{
		startingSong = false;
		songStarted = true;
		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
		{
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		}

		FlxG.sound.music.onComplete = endSong;
		vocals.play();

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		if (FlxG.save.data.songPosition)
		{
			remove(songPosBG);
			remove(songPosBar);
			remove(songName);

			songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
			if (PlayStateChangeables.useDownscroll)
				songPosBG.y = FlxG.height * 0.9 + 45; 
			songPosBG.screenCenter(X);
			songPosBG.scrollFactor.set();
			add(songPosBG);

			songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
				'songPositionBar', 0, songLength - 1000);
			songPosBar.numDivisions = 1000;
			songPosBar.scrollFactor.set();
			songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
			add(songPosBar);

			var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - (SONG.song.length * 5),songPosBG.y,0,SONG.song, 16);
			if (PlayStateChangeables.useDownscroll)
				songName.y -= 3;
			songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			songName.scrollFactor.set();
			add(songName);

			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
			songName.cameras = [camHUD];
		}
		
		// Song check real quick
		switch(curSong)
		{
			case 'Bopeebo' | 'Philly Nice' | 'Blammed' | 'Cocoa' | 'Eggnog': allowedToHeadbang = true;
			default: allowedToHeadbang = false;
		}

		if (useVideo)
			GlobalVideo.get().resume();
		
		#if windows
		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		trace('loaded vocals');

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		// Per song offset check
		#if windows
			// pre lowercasing the song name (generateSong)
			var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
				switch (songLowercase) {
					case 'dad-battle': songLowercase = 'dadbattle';
					case 'philly-nice': songLowercase = 'philly';
					case 'satin-panties': songLowercase = 'satin panties';
					case 'church-lords': songLowercase = 'church lords';
					case 'gospel-remix': songLowercase = 'gospel remix';
					case 'it\'s-been-so-long': songLowercase = 'it\'s been so long';
					case 'panic-stricken': songLowercase = 'panic stricken';
					case 'ruv-jug': songLowercase = 'ruv jug';
					case 'ruvved-up': songLowercase = 'ruvved up';
					case 'too-clergy': songLowercase = 'too clergy';
					case 'tutorial-remix': songLowercase = 'tutorial remix';
					case 'zavodila-remix': songLowercase = 'zavodila remix';
				}

			var songPath = 'assets/data/' + songLowercase + '/';
			
			for(file in sys.FileSystem.readDirectory(songPath))
			{
				var path = haxe.io.Path.join([songPath, file]);
				if(!sys.FileSystem.isDirectory(path))
				{
					if(path.endsWith('.offset'))
					{
						trace('Found offset file: ' + path);
						songOffset = Std.parseFloat(file.substring(0, file.indexOf('.off')));
						break;
					}else {
						trace('Offset file not found. Creating one @: ' + songPath);
						sys.io.File.saveContent(songPath + songOffset + '.offset', '');
					}
				}
			}
		#end
		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0] + FlxG.save.data.offset + songOffset;
				if (daStrumTime < 0)
					daStrumTime = 0;
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);

				if (!gottaHitNote && PlayStateChangeables.Optimize)
					continue;

				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else
				{
				}
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);

			//defaults if no noteStyle was found in chart
			var noteTypeCheck:String = 'normal';
		
			if (PlayStateChangeables.Optimize && player == 0)
				continue;

			if (SONG.noteStyle == null) {
				switch(storyWeek) {case 6: noteTypeCheck = 'pixel';}
			} else {noteTypeCheck = SONG.noteStyle;}

			switch (noteTypeCheck)
			{
				case 'pixel':
					babyArrow.loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
					}

				case 'xmas':

					babyArrow.frames = Paths.getSparrowAtlas('christmas/xmas_ui/notes_xmas', 'week5');
					babyArrow.animation.addByPrefix('green', 'arrow static instance 1');
					babyArrow.animation.addByPrefix('blue', 'arrow static instance 2');
					babyArrow.animation.addByPrefix('purple', 'arrow static instance 3');
					babyArrow.animation.addByPrefix('red', 'arrow static instance 4');
	
					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
	
					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 1');
							babyArrow.animation.addByPrefix('pressed', 'left press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm instance 1', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 2');
							babyArrow.animation.addByPrefix('pressed', 'down press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm instance 1', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 4');
							babyArrow.animation.addByPrefix('pressed', 'up press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm instance 1', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 3');
							babyArrow.animation.addByPrefix('pressed', 'right press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm instance 1', 24, false);
						}

				case 'sarvente':

					babyArrow.frames = Paths.getSparrowAtlas('NOTE_Assets_Sarvente');
					babyArrow.animation.addByPrefix('green', 'arrow static instance 1');
					babyArrow.animation.addByPrefix('blue', 'arrow static instance 2');
					babyArrow.animation.addByPrefix('purple', 'arrow static instance 3');
					babyArrow.animation.addByPrefix('red', 'arrow static instance 4');
	
					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
	
					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 1');
							babyArrow.animation.addByPrefix('pressed', 'left press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm instance 1', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 2');
							babyArrow.animation.addByPrefix('pressed', 'down press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm instance 1', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 4');
							babyArrow.animation.addByPrefix('pressed', 'up press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm instance 1', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 3');
							babyArrow.animation.addByPrefix('pressed', 'right press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm instance 1', 24, false);
						}

				case 'dark-sarv':

					babyArrow.frames = Paths.getSparrowAtlas('NOTE_Assets_Dark-Sarv');
					babyArrow.animation.addByPrefix('green', 'arrow static instance 1');
					babyArrow.animation.addByPrefix('blue', 'arrow static instance 2');
					babyArrow.animation.addByPrefix('purple', 'arrow static instance 3');
					babyArrow.animation.addByPrefix('red', 'arrow static instance 4');
	
					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
	
					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 1');
							babyArrow.animation.addByPrefix('pressed', 'left press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm instance 1', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 2');
							babyArrow.animation.addByPrefix('pressed', 'down press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm instance 1', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 4');
							babyArrow.animation.addByPrefix('pressed', 'up press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm instance 1', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 3');
							babyArrow.animation.addByPrefix('pressed', 'right press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm instance 1', 24, false);
						}

				case 'ruv':

					babyArrow.frames = Paths.getSparrowAtlas('NOTE_Assets_Ruv');
					babyArrow.animation.addByPrefix('green', 'arrow static instance 1');
					babyArrow.animation.addByPrefix('blue', 'arrow static instance 2');
					babyArrow.animation.addByPrefix('purple', 'arrow static instance 3');
					babyArrow.animation.addByPrefix('red', 'arrow static instance 4');
	
					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
	
					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 1');
							babyArrow.animation.addByPrefix('pressed', 'left press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm instance 1', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 2');
							babyArrow.animation.addByPrefix('pressed', 'down press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm instance 1', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 4');
							babyArrow.animation.addByPrefix('pressed', 'up press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm instance 1', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 3');
							babyArrow.animation.addByPrefix('pressed', 'right press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm instance 1', 24, false);
						}

				case 'luci-sarv-alt':

					babyArrow.frames = Paths.getSparrowAtlas('NOTE_Assets_Luci-Sarv-Alt');
					babyArrow.animation.addByPrefix('green', 'arrow static instance 1');
					babyArrow.animation.addByPrefix('blue', 'arrow static instance 2');
					babyArrow.animation.addByPrefix('purple', 'arrow static instance 3');
					babyArrow.animation.addByPrefix('red', 'arrow static instance 4');
	
					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
	
					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 1');
							babyArrow.animation.addByPrefix('pressed', 'left press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm instance 1', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 2');
							babyArrow.animation.addByPrefix('pressed', 'down press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm instance 1', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 4');
							babyArrow.animation.addByPrefix('pressed', 'up press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm instance 1', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 3');
							babyArrow.animation.addByPrefix('pressed', 'right press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm instance 1', 24, false);
						}

				case 'luci-sarv':

					babyArrow.frames = Paths.getSparrowAtlas('NOTE_Assets_Luci-Sarv');
					babyArrow.animation.addByPrefix('green', 'arrow static instance 1');
					babyArrow.animation.addByPrefix('blue', 'arrow static instance 2');
					babyArrow.animation.addByPrefix('purple', 'arrow static instance 3');
					babyArrow.animation.addByPrefix('red', 'arrow static instance 4');
	
					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
	
					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 1');
							babyArrow.animation.addByPrefix('pressed', 'left press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm instance 1', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 2');
							babyArrow.animation.addByPrefix('pressed', 'down press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm instance 1', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 4');
							babyArrow.animation.addByPrefix('pressed', 'up press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm instance 1', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 3');
							babyArrow.animation.addByPrefix('pressed', 'right press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm instance 1', 24, false);
						}

				case 'selever':

					babyArrow.frames = Paths.getSparrowAtlas('NOTE_Assets_Selever');
					babyArrow.animation.addByPrefix('green', 'arrow static instance 1');
					babyArrow.animation.addByPrefix('blue', 'arrow static instance 2');
					babyArrow.animation.addByPrefix('purple', 'arrow static instance 3');
					babyArrow.animation.addByPrefix('red', 'arrow static instance 4');
	
					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
	
					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 1');
							babyArrow.animation.addByPrefix('pressed', 'left press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm instance 1', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 2');
							babyArrow.animation.addByPrefix('pressed', 'down press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm instance 1', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 4');
							babyArrow.animation.addByPrefix('pressed', 'up press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm instance 1', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 3');
							babyArrow.animation.addByPrefix('pressed', 'right press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm instance 1', 24, false);
						}

				case 'gf':

					babyArrow.frames = Paths.getSparrowAtlas('NOTE_Assets_GF');
					babyArrow.animation.addByPrefix('green', 'arrow static instance 1');
					babyArrow.animation.addByPrefix('blue', 'arrow static instance 2');
					babyArrow.animation.addByPrefix('purple', 'arrow static instance 3');
					babyArrow.animation.addByPrefix('red', 'arrow static instance 4');
	
					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
	
					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 1');
							babyArrow.animation.addByPrefix('pressed', 'left press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm instance 1', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 2');
							babyArrow.animation.addByPrefix('pressed', 'down press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm instance 1', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 4');
							babyArrow.animation.addByPrefix('pressed', 'up press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm instance 1', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 3');
							babyArrow.animation.addByPrefix('pressed', 'right press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm instance 1', 24, false);
						}
				
				case 'normal':
					babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
					babyArrow.animation.addByPrefix('green', 'arrow static instance 1');
					babyArrow.animation.addByPrefix('blue', 'arrow static instance 2');
					babyArrow.animation.addByPrefix('purple', 'arrow static instance 3');
					babyArrow.animation.addByPrefix('red', 'arrow static instance 4');
	
					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
	
					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 1');
							babyArrow.animation.addByPrefix('pressed', 'left press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm instance 1', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 2');
							babyArrow.animation.addByPrefix('pressed', 'down press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm instance 1', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 4');
							babyArrow.animation.addByPrefix('pressed', 'up press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm instance 1', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 3');
							babyArrow.animation.addByPrefix('pressed', 'right press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm instance 1', 24, false);
						}

				default:
					babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
					babyArrow.animation.addByPrefix('green', 'arrow static instance 1');
					babyArrow.animation.addByPrefix('blue', 'arrow static instance 2');
					babyArrow.animation.addByPrefix('purple', 'arrow static instance 3');
					babyArrow.animation.addByPrefix('red', 'arrow static instance 4');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 1');
							babyArrow.animation.addByPrefix('pressed', 'left press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm instance 1', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 2');
							babyArrow.animation.addByPrefix('pressed', 'down press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm instance 1', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 4');
							babyArrow.animation.addByPrefix('pressed', 'up press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm instance 1', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrow static instance 3');
							babyArrow.animation.addByPrefix('pressed', 'right press instance 1', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm instance 1', 24, false);
					}
			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			if (!isStoryMode)
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}

			babyArrow.ID = i;

			switch (player)
			{
				case 0:
					cpuStrums.add(babyArrow);
				case 1:
					playerStrums.add(babyArrow);
			}

			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);
			
			if (PlayStateChangeables.Optimize)
				babyArrow.x -= 275;
			
			cpuStrums.forEach(function(spr:FlxSprite)
			{					
				spr.centerOffsets(); //CPU arrows start out slightly off-center
			});

			strumLineNotes.add(babyArrow);
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			#if windows
			DiscordClient.changePresence("PAUSED on " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end
			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if windows
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses, iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), iconRPC);
			}
			#end
		}

		super.closeSubState();
	}
	

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();

		#if windows
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;
	var nps:Int = 0;
	var maxNPS:Int = 0;

	public static var songRate = 1.5;

	public var stopUpdate = false;
	public var removedVideo = false;

	override public function update(elapsed:Float)
	{
		#if !debug
		perfectMode = false;
		#end

		if (PlayStateChangeables.botPlay && FlxG.keys.justPressed.ONE)
			camHUD.visible = !camHUD.visible;


		if (useVideo && GlobalVideo.get() != null && !stopUpdate)
			{		
				if (GlobalVideo.get().ended && !removedVideo)
				{
					remove(videoSprite);
					FlxG.stage.window.onFocusOut.remove(focusOut);
					FlxG.stage.window.onFocusIn.remove(focusIn);
					removedVideo = true;
				}
			}


		
		#if windows
		if (executeModchart && luaModchart != null && songStarted)
		{
			luaModchart.setVar('songPos',Conductor.songPosition);
			luaModchart.setVar('hudZoom', camHUD.zoom);
			luaModchart.setVar('cameraZoom',FlxG.camera.zoom);
			luaModchart.executeState('update', [elapsed]);

			for (i in luaWiggles)
			{
				trace('wiggle le gaming');
				i.update(elapsed);
			}

			/*for (i in 0...strumLineNotes.length) {
				var member = strumLineNotes.members[i];
				member.x = luaModchart.getVar("strum" + i + "X", "float");
				member.y = luaModchart.getVar("strum" + i + "Y", "float");
				member.angle = luaModchart.getVar("strum" + i + "Angle", "float");
			}*/

			FlxG.camera.angle = luaModchart.getVar('cameraAngle', 'float');
			camHUD.angle = luaModchart.getVar('camHudAngle','float');

			if (luaModchart.getVar("showOnlyStrums",'bool'))
			{
				healthBarBG.visible = false;
				kadeEngineWatermark.visible = false;
				healthBar.visible = false;
				iconP1.visible = false;
				iconP2.visible = false;
				scoreTxt.visible = false;
			}
			else
			{
				healthBarBG.visible = true;
				kadeEngineWatermark.visible = true;
				healthBar.visible = true;
				iconP1.visible = true;
				iconP2.visible = true;
				scoreTxt.visible = true;
			}

			var p1 = luaModchart.getVar("strumLine1Visible",'bool');
			var p2 = luaModchart.getVar("strumLine2Visible",'bool');

			for (i in 0...4)
			{
				strumLineNotes.members[i].visible = p1;
				if (i <= playerStrums.length)
					playerStrums.members[i].visible = p2;
			}
		}

		#end

		// reverse iterate to remove oldest notes first and not invalidate the iteration
		// stop iteration as soon as a note is not removed
		// all notes should be kept in the correct order and this is optimal, safe to do every frame/update
		{
			var balls = notesHitArray.length-1;
			while (balls >= 0)
			{
				var cock:Date = notesHitArray[balls];
				if (cock != null && cock.getTime() + 1000 < Date.now().getTime())
					notesHitArray.remove(cock);
				else
					balls = 0;
				balls--;
			}
			nps = notesHitArray.length;
			if (nps > maxNPS)
				maxNPS = nps;
		}

		switch (curStage)
		{
			case 'philly':
				if (trainMoving && !PlayStateChangeables.Optimize)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
				// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;
		}

		super.update(elapsed);

		scoreTxt.text = Ratings.CalculateRanking(songScore,songScoreDef,nps,maxNPS,accuracy);

		var lengthInPx = scoreTxt.textField.length * scoreTxt.frameHeight; // bad way but does more or less a better job

		scoreTxt.x = (originalX - (lengthInPx / 2)) + 335;

		if (controls.PAUSE && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				trace('GITAROO MAN EASTER EGG');
				FlxG.switchState(new GitarooPause());
			}
			else
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}


		if (FlxG.keys.justPressed.SEVEN)
		{
			if (useVideo)
				{
					GlobalVideo.get().stop();
					remove(videoSprite);
					FlxG.stage.window.onFocusOut.remove(focusOut);
					FlxG.stage.window.onFocusIn.remove(focusIn);
					removedVideo = true;
				}
			#if windows
			DiscordClient.changePresence("Chart Editor", null, null, true);
			#end
			FlxG.switchState(new ChartingState());
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,handleInput);
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.50)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.50)));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > 2)
			health = 2;
		if (healthBar.percent < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (healthBar.percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else
			iconP2.animation.curAnim.curFrame = 0;

		/* if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new Charting()); */

		#if debug
		if (FlxG.keys.justPressed.SIX)
		{
			if (useVideo)
				{
					GlobalVideo.get().stop();
					remove(videoSprite);
					FlxG.stage.window.onFocusOut.remove(focusOut);
					FlxG.stage.window.onFocusIn.remove(focusIn);
					removedVideo = true;
				}

			FlxG.switchState(new AnimationDebug(SONG.player2));
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,handleInput);
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		if (FlxG.keys.justPressed.ZERO)
		{
			FlxG.switchState(new AnimationDebug(SONG.player1));
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,handleInput);
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		if (FlxG.keys.justPressed.NINE)
		{
			FlxG.switchState(new AnimationDebug(gf.curCharacter));
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,handleInput);
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		#end

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;
			/*@:privateAccess
			{
				FlxG.sound.music._channel.
			}*/
			songPositionBar = Conductor.songPosition;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			// Make sure Girlfriend cheers only for certain songs
			if(allowedToHeadbang)
			{
				// Don't animate GF if something else is already animating her (eg. train passing)
				if(gf.animation.curAnim.name == 'danceLeft' || gf.animation.curAnim.name == 'danceRight' || gf.animation.curAnim.name == 'idle')
				{
					// Per song treatment since some songs will only have the 'Hey' at certain times
					switch(curSong)
					{
						case 'Philly Nice':
						{
							// General duration of the song
							if(curBeat < 250)
							{
								// Beats to skip or to stop GF from cheering
								if(curBeat != 184 && curBeat != 216)
								{
									if(curBeat % 16 == 8)
									{
										// Just a garantee that it'll trigger just once
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Bopeebo':
						{
							// Where it starts || where it ends
							if(curBeat > 5 && curBeat < 130)
							{
								if(curBeat % 8 == 7)
								{
									if(!triggeredAlready)
									{
										gf.playAnim('cheer');
										triggeredAlready = true;
									}
								}else triggeredAlready = false;
							}
						}
						case 'Blammed':
						{
							if(curBeat > 30 && curBeat < 190)
							{
								if(curBeat < 90 || curBeat > 128)
								{
									if(curBeat % 4 == 2)
									{
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Cocoa':
						{
							if(curBeat < 170)
							{
								if(curBeat < 65 || curBeat > 130 && curBeat < 145)
								{
									if(curBeat % 16 == 15)
									{
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Eggnog':
						{
							if(curBeat > 10 && curBeat != 111 && curBeat < 220)
							{
								if(curBeat % 8 == 7)
								{
									if(!triggeredAlready)
									{
										gf.playAnim('cheer');
										triggeredAlready = true;
									}
								}else triggeredAlready = false;
							}
						}
					}
				}
			}
			
			#if windows
			if (luaModchart != null)
				luaModchart.setVar("mustHit",PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);
			#end

			if (camFollow.x != dad.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
			{
				var offsetX = 0;
				var offsetY = 0;
				#if windows
				if (luaModchart != null)
				{
					offsetX = luaModchart.getVar("followXOffset", "float");
					offsetY = luaModchart.getVar("followYOffset", "float");
				}
				#end
				camFollow.setPosition(dad.getMidpoint().x + 150 + offsetX, dad.getMidpoint().y - 100 + offsetY);
				#if windows
				if (luaModchart != null)
					luaModchart.executeState('playerTwoTurn', []);
				#end
				// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

				switch (dad.curCharacter)
				{
					case 'mom':
						camFollow.y = dad.getMidpoint().y;
					case 'senpai':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'senpai-angry':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
				}

				if (dad.curCharacter == 'mom')
					vocals.volume = 1;
			}

			if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
			{
				var offsetX = 0;
				var offsetY = 0;
				#if windows
				if (luaModchart != null)
				{
					offsetX = luaModchart.getVar("followXOffset", "float");
					offsetY = luaModchart.getVar("followYOffset", "float");
				}
				#end
				camFollow.setPosition(boyfriend.getMidpoint().x - 100 + offsetX, boyfriend.getMidpoint().y - 100 + offsetY);

				#if windows
				if (luaModchart != null)
					luaModchart.executeState('playerOneTurn', []);
				#end

				switch (curStage)
				{
					case 'limo':
						camFollow.x = boyfriend.getMidpoint().x - 300;
					case 'mall':
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'school':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'schoolEvil':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
				}
			}
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (curSong == 'Fresh')
		{
			switch (curBeat)
			{
				case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
				case 163:
					// FlxG.sound.music.stop();
					// FlxG.switchState(new TitleState());
			}
		}

		if (curSong == 'Bopeebo')
		{
			switch (curBeat)
			{
				case 128, 129, 130:
					vocals.volume = 0;
					// FlxG.sound.music.stop();
					// FlxG.switchState(new PlayState());
			}
		}

		if (health <= 0)
		{
			boyfriend.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();

			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			#if windows
			// Game Over doesn't get his own variable because it's only used here
			DiscordClient.changePresence("GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy),"\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end

			// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}
 		if (FlxG.save.data.resetButton)
		{
			if(FlxG.keys.justPressed.R && inCutscene == false)
				{
					boyfriend.stunned = true;

					persistentUpdate = false;
					persistentDraw = false;
					paused = true;
		
					vocals.stop();
					FlxG.sound.music.stop();
		
					openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		
					#if windows
					// Game Over doesn't get his own variable because it's only used here
					DiscordClient.changePresence("GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy),"\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
					#end
		
					// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
				}
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 3500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
			{
				notes.forEachAlive(function(daNote:Note)
				{	

					// instead of doing stupid y > FlxG.height
					// we be men and actually calculate the time :)
					if (daNote.tooLate)
					{
						daNote.active = false;
						daNote.visible = false;
					}
					else
					{
						daNote.visible = true;
						daNote.active = true;
					}
					
					if (!daNote.modifiedByLua)
						{
							if (PlayStateChangeables.useDownscroll)
							{
								if (daNote.mustPress)
									daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y + 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed, 2));
								else
									daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed, 2));
								if(daNote.isSustainNote)
								{
									// Remember = minus makes notes go up, plus makes them go down
									if(daNote.animation.curAnim.name.endsWith('end') && daNote.prevNote != null)
										daNote.y += daNote.prevNote.height;
									else
										daNote.y += daNote.height / 2;
	
									// If not in botplay, only clip sustain notes when properly hit, botplay gets to clip it everytime
									if(!PlayStateChangeables.botPlay)
									{
										if((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit) && daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= (strumLine.y + Note.swagWidth / 2))
										{
											// Clip to strumline
											var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
											swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
											swagRect.y = daNote.frameHeight - swagRect.height;
	
											daNote.clipRect = swagRect;
										}
									}else {
										var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
										swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
										swagRect.y = daNote.frameHeight - swagRect.height;
	
										daNote.clipRect = swagRect;
									}
								}
							}else
							{
								if (daNote.mustPress)
									daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y - 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed, 2));
								else
									daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y - 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed, 2));
								if(daNote.isSustainNote)
								{
									daNote.y -= daNote.height / 2;
	
									if(!PlayStateChangeables.botPlay)
									{
										if((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit) && daNote.y + daNote.offset.y * daNote.scale.y <= (strumLine.y + Note.swagWidth / 2))
										{
											// Clip to strumline
											var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
											swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
											swagRect.height -= swagRect.y;
	
											daNote.clipRect = swagRect;
										}
									}else {
										var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
										swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
										swagRect.height -= swagRect.y;
	
										daNote.clipRect = swagRect;
									}
								}
							}
						}
		
	
					if (!daNote.mustPress && daNote.wasGoodHit)
					{
						if (SONG.song != 'Tutorial')
							camZooming = true;

						var altAnim:String = "";
	
						if (SONG.notes[Math.floor(curStep / 16)] != null)
						{
							if (SONG.notes[Math.floor(curStep / 16)].altAnim)
								altAnim = '-alt';
						}
	
						switch (Math.abs(daNote.noteData))
						{
							case 2:
								dad.playAnim('singUP' + altAnim, true);
							case 3:
								dad.playAnim('singRIGHT' + altAnim, true);
							case 1:
								dad.playAnim('singDOWN' + altAnim, true);
							case 0:
								dad.playAnim('singLEFT' + altAnim, true);
						}
						
						if (FlxG.save.data.cpuStrums)
						{
							cpuStrums.forEach(function(spr:FlxSprite)
							{
								if (Math.abs(daNote.noteData) == spr.ID)
								{
									spr.animation.play('confirm', true);
								}
								if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
								{
									spr.centerOffsets();
									spr.offset.x -= 13;
									spr.offset.y -= 13;
								}
								else
									spr.centerOffsets();
							});
						}
	
						#if windows
						if (luaModchart != null)
							luaModchart.executeState('playerTwoSing', [Math.abs(daNote.noteData), Conductor.songPosition]);
						#end

						dad.holdTimer = 0;
	
						if (SONG.needsVoices)
							vocals.volume = 1;
	
						daNote.active = false;


						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}

					if (daNote.mustPress && !daNote.modifiedByLua)
					{
						daNote.visible = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].visible;
						daNote.x = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].x;
						if (!daNote.isSustainNote)
							daNote.angle = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].angle;
						daNote.alpha = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].alpha;
					}
					else if (!daNote.wasGoodHit && !daNote.modifiedByLua)
					{
						daNote.visible = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].visible;
						daNote.x = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].x;
						if (!daNote.isSustainNote)
							daNote.angle = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].angle;
						daNote.alpha = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].alpha;
					}
					
					

					if (daNote.isSustainNote)
						daNote.x += daNote.width / 2 + 17;
					

					//trace(daNote.y);
					// WIP interpolation shit? Need to fix the pause issue
					// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));
	
					if ((daNote.mustPress && daNote.tooLate && !PlayStateChangeables.useDownscroll || daNote.mustPress && daNote.tooLate && PlayStateChangeables.useDownscroll) && daNote.mustPress)
					{
							if (daNote.isSustainNote && daNote.wasGoodHit)
							{
								daNote.kill();
								notes.remove(daNote, true);
							}
							else
							{
								if (loadRep && daNote.isSustainNote)
								{
									// im tired and lazy this sucks I know i'm dumb
									if (findByTime(daNote.strumTime) != null)
										totalNotesHit += 1;
									else
									{
										health -= 0.075;
										vocals.volume = 0;
										if (theFunne)
											noteMiss(daNote.noteData, daNote);
									}
								}
								else
								{
									health -= 0.075;
									vocals.volume = 0;
									if (theFunne)
										noteMiss(daNote.noteData, daNote);
								}
							}
		
							daNote.visible = false;
							daNote.kill();
							notes.remove(daNote, true);
						}
					
				});
			}

		if (FlxG.save.data.cpuStrums)
		{
			cpuStrums.forEach(function(spr:FlxSprite)
			{
				if (spr.animation.finished)
				{
					spr.animation.play('static');
					spr.centerOffsets();
				}
			});
		}

		if (!inCutscene)
			keyShit();


		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end
	}

	function endSong():Void
	{
		FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,handleInput);
		if (useVideo)
			{
				GlobalVideo.get().stop();
				FlxG.stage.window.onFocusOut.remove(focusOut);
				FlxG.stage.window.onFocusIn.remove(focusIn);
				PlayState.instance.remove(PlayState.instance.videoSprite);
			}

		if (isStoryMode)
			campaignMisses = misses;

		if (!loadRep)
			rep.SaveReplay(saveNotes, saveJudge, replayAna);
		else
		{
			PlayStateChangeables.botPlay = false;
			PlayStateChangeables.scrollSpeed = 1;
			PlayStateChangeables.useDownscroll = false;
		}

		if (FlxG.save.data.fpsCap > 290)
			(cast (Lib.current.getChildAt(0), Main)).setFPSCap(290);

		#if windows
		if (luaModchart != null)
		{
			luaModchart.die();
			luaModchart = null;
		}
		#end

		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		FlxG.sound.music.pause();
		vocals.pause();
		if (SONG.validScore)
		{
			// adjusting the highscore song name to be compatible
			// would read original scores if we didn't change packages
			var songHighscore = StringTools.replace(PlayState.SONG.song, " ", "-");
			switch (songHighscore) {
				case 'Dad-Battle': songHighscore = 'Dadbattle';
				case 'Philly-Nice': songHighscore = 'Philly';
				case 'Satin-Panties': songHighscore = 'Satin Panties';
				case 'Church-Lords': songHighscore = 'Church Lords';
				case 'Gospel-Remix': songHighscore = 'Gospel Remix';
				case 'It\'s-Been-So-Long': songHighscore = 'It\'s Been So Long';
				case 'Panic-Stricken': songHighscore = 'Panic Stricken';
				case 'Ruv-Jug': songHighscore = 'Ruv Jug';
				case 'Ruvved-Up': songHighscore = 'Ruvved Up';
				case 'Too-Clergy': songHighscore = 'Too Clergy';
				case 'Tutorial-Remix': songHighscore = 'Tutorial Remix';
				case 'Zavodila-Remix': songHighscore = 'Zavodila Remix';
			}

			#if !switch
			Highscore.saveScore(songHighscore, Math.round(songScore), storyDifficulty);
			Highscore.saveCombo(songHighscore, Ratings.GenerateLetterRank(accuracy), storyDifficulty);
			#end
		}

		if (offsetTesting)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			offsetTesting = false;
			LoadingState.loadAndSwitchState(new OptionsMenu());
			FlxG.save.data.offset = offsetTest;
		}
		else
		{
			if (isStoryMode)
			{
				campaignScore += Math.round(songScore);

				storyPlaylist.remove(storyPlaylist[0]);

				if (storyPlaylist.length <= 0)
				{
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;

					paused = true;

					FlxG.sound.music.stop();
					vocals.stop();
					if (FlxG.save.data.scoreScreen)
						openSubState(new ResultsScreen());
					else
					{
						FlxG.sound.playMusic(Paths.music('freakyMenu'));
						FlxG.switchState(new MainMenuState());
					}

					#if windows
					if (luaModchart != null)
					{
						luaModchart.die();
						luaModchart = null;
					}
					#end

					// if ()
					StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

					if (SONG.validScore)
					{
						NGio.unlockMedal(60961);
						Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
					}

					FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
					FlxG.save.flush();
				}
				else
				{
					
					// adjusting the song name to be compatible
					var songFormat = StringTools.replace(PlayState.storyPlaylist[0], " ", "-");
					switch (songFormat) {
						case 'Dad-Battle': songFormat = 'Dadbattle';
						case 'Philly-Nice': songFormat = 'Philly';
						case 'Satin-Panties': songFormat = 'Satin Panties';
						case 'Church-Lords': songFormat = 'Church Lords';
						case 'Gospel-Remix': songFormat = 'Gospel Remix';
						case 'It\'s-Been-So-Long': songFormat = 'It\'s Been So Long';
						case 'Panic-Stricken': songFormat = 'Panic Stricken';
						case 'Ruv-Jug': songFormat = 'Ruv Jug';
						case 'Ruvved-Up': songFormat = 'Ruvved Up';
						case 'Too-Clergy': songFormat = 'Too Clergy';
						case 'Tutorial-Remix': songFormat = 'Tutorial Remix';
						case 'Zavodila-Remix': songFormat = 'Zavodila Remix';
					}

					var poop:String = Highscore.formatSong(songFormat, storyDifficulty);

					trace('LOADING NEXT SONG');
					trace(poop);

					if (StringTools.replace(PlayState.storyPlaylist[0], " ", "-").toLowerCase() == 'eggnog')
					{
						var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
							-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
						blackShit.scrollFactor.set();
						add(blackShit);
						camHUD.visible = false;

						FlxG.sound.play(Paths.sound('Lights_Shut_off'));
					}

					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;
					prevCamFollow = camFollow;


					PlayState.SONG = Song.loadFromJson(poop, PlayState.storyPlaylist[0]);
					FlxG.sound.music.stop();

					LoadingState.loadAndSwitchState(new PlayState());
				}
			}
			else
			{
				trace('WENT BACK TO FREEPLAY??');

				paused = true;


				FlxG.sound.music.stop();
				vocals.stop();

				if (FlxG.save.data.scoreScreen)
					openSubState(new ResultsScreen());
				else
					FlxG.switchState(new FreeplayState());
			}
		}
	}


	var endingSong:Bool = false;

	var hits:Array<Float> = [];
	var offsetTest:Float = 0;

	var timeShown = 0;
	var currentTimingShown:FlxText = null;

	private function popUpScore(daNote:Note):Void
		{
			var noteDiff:Float = -(daNote.strumTime - Conductor.songPosition);
			var wife:Float = EtternaFunctions.wife3(-noteDiff, Conductor.timeScale);
			// boyfriend.playAnim('hey');
			vocals.volume = 1;
			var placement:String = Std.string(combo);
	
			var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
			coolText.screenCenter();
			coolText.x = FlxG.width * 0.55;
			coolText.y -= 350;
			coolText.cameras = [camHUD];
			//
	
			var rating:FlxSprite = new FlxSprite();
			var score:Float = 350;

			if (FlxG.save.data.accuracyMod == 1)
				totalNotesHit += wife;

			var daRating = daNote.rating;

			switch(daRating)
			{
				case 'shit':
					score = -300;
					combo = 0;
					misses++;
					health -= 0.2;
					ss = false;
					shits++;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit -= 1;
				case 'bad':
					daRating = 'bad';
					score = 0;
					health -= 0.06;
					ss = false;
					bads++;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 0.50;
				case 'good':
					daRating = 'good';
					score = 200;
					ss = false;
					goods++;
					if (health < 2)
						health += 0.04;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 0.75;
				case 'sick':
					if (health < 2)
						health += 0.1;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 1;
					sicks++;
			}

			// trace('Wife accuracy loss: ' + wife + ' | Rating: ' + daRating + ' | Score: ' + score + ' | Weight: ' + (1 - wife));

			if (daRating != 'shit' || daRating != 'bad')
				{
	
	
			songScore += Math.round(score);
			songScoreDef += Math.round(ConvertScore.convertScore(noteDiff));
	
			/* if (combo > 60)
					daRating = 'sick';
				else if (combo > 12)
					daRating = 'good'
				else if (combo > 4)
					daRating = 'bad';
			 */
	
			var pixelShitPart1:String = "";
			var pixelShitPart2:String = '';
	
			if (curStage.startsWith('school'))
			{
				pixelShitPart1 = 'weeb/pixelUI/';
				pixelShitPart2 = '-pixel';
			}
	
			rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
			rating.screenCenter();
			rating.y -= 50;
			rating.x = coolText.x - 125;
			
			if (FlxG.save.data.changedHit)
			{
				rating.x = FlxG.save.data.changedHitX;
				rating.y = FlxG.save.data.changedHitY;
			}
			rating.acceleration.y = 550;
			rating.velocity.y -= FlxG.random.int(140, 175);
			rating.velocity.x -= FlxG.random.int(0, 10);
			
			var msTiming = HelperFunctions.truncateFloat(noteDiff, 3);
			if(PlayStateChangeables.botPlay && !loadRep) msTiming = 0;		
			
			if (loadRep)
				msTiming = HelperFunctions.truncateFloat(findByTime(daNote.strumTime)[3], 3);

			if (currentTimingShown != null)
				remove(currentTimingShown);

			currentTimingShown = new FlxText(0,0,0,"0ms");
			timeShown = 0;
			switch(daRating)
			{
				case 'shit' | 'bad':
					currentTimingShown.color = FlxColor.RED;
				case 'good':
					currentTimingShown.color = FlxColor.GREEN;
				case 'sick':
					currentTimingShown.color = FlxColor.CYAN;
			}
			currentTimingShown.borderStyle = OUTLINE;
			currentTimingShown.borderSize = 1;
			currentTimingShown.borderColor = FlxColor.BLACK;
			currentTimingShown.text = msTiming + "ms";
			currentTimingShown.size = 20;

			if (msTiming >= 0.03 && offsetTesting)
			{
				//Remove Outliers
				hits.shift();
				hits.shift();
				hits.shift();
				hits.pop();
				hits.pop();
				hits.pop();
				hits.push(msTiming);

				var total = 0.0;

				for(i in hits)
					total += i;
				

				
				offsetTest = HelperFunctions.truncateFloat(total / hits.length,2);
			}

			if (currentTimingShown.alpha != 1)
				currentTimingShown.alpha = 1;

			if(!PlayStateChangeables.botPlay || loadRep) add(currentTimingShown);
			
			var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
			comboSpr.screenCenter();
			comboSpr.x = rating.x;
			comboSpr.y = rating.y + 100;
			comboSpr.acceleration.y = 600;
			comboSpr.velocity.y -= 150;

			currentTimingShown.screenCenter();
			currentTimingShown.x = comboSpr.x + 100;
			currentTimingShown.y = rating.y + 100;
			currentTimingShown.acceleration.y = 600;
			currentTimingShown.velocity.y -= 150;
	
			comboSpr.velocity.x += FlxG.random.int(1, 10);
			currentTimingShown.velocity.x += comboSpr.velocity.x;
			if(!PlayStateChangeables.botPlay || loadRep) add(rating);
	
			if (!curStage.startsWith('school'))
			{
				rating.setGraphicSize(Std.int(rating.width * 0.7));
				rating.antialiasing = true;
				comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
				comboSpr.antialiasing = true;
			}
			else
			{
				rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
				comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
			}
	
			currentTimingShown.updateHitbox();
			comboSpr.updateHitbox();
			rating.updateHitbox();
	
			currentTimingShown.cameras = [camHUD];
			comboSpr.cameras = [camHUD];
			rating.cameras = [camHUD];

			var seperatedScore:Array<Int> = [];
	
			var comboSplit:Array<String> = (combo + "").split('');

			if (combo > highestCombo)
				highestCombo = combo;

			// make sure we have 3 digits to display (looks weird otherwise lol)
			if (comboSplit.length == 1)
			{
				seperatedScore.push(0);
				seperatedScore.push(0);
			}
			else if (comboSplit.length == 2)
				seperatedScore.push(0);

			for(i in 0...comboSplit.length)
			{
				var str:String = comboSplit[i];
				seperatedScore.push(Std.parseInt(str));
			}
	
			var daLoop:Int = 0;
			for (i in seperatedScore)
			{
				var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
				numScore.screenCenter();
				numScore.x = rating.x + (43 * daLoop) - 50;
				numScore.y = rating.y + 100;
				numScore.cameras = [camHUD];

				if (!curStage.startsWith('school'))
				{
					numScore.antialiasing = true;
					numScore.setGraphicSize(Std.int(numScore.width * 0.5));
				}
				else
				{
					numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
				}
				numScore.updateHitbox();
	
				numScore.acceleration.y = FlxG.random.int(200, 300);
				numScore.velocity.y -= FlxG.random.int(140, 160);
				numScore.velocity.x = FlxG.random.float(-5, 5);
	
				add(numScore);
	
				FlxTween.tween(numScore, {alpha: 0}, 0.2, {
					onComplete: function(tween:FlxTween)
					{
						numScore.destroy();
					},
					startDelay: Conductor.crochet * 0.002
				});
	
				daLoop++;
			}
			/* 
				trace(combo);
				trace(seperatedScore);
			 */
	
			coolText.text = Std.string(seperatedScore);
			// add(coolText);
	
			FlxTween.tween(rating, {alpha: 0}, 0.2, {
				startDelay: Conductor.crochet * 0.001,
				onUpdate: function(tween:FlxTween)
				{
					if (currentTimingShown != null)
						currentTimingShown.alpha -= 0.02;
					timeShown++;
				}
			});

			FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					coolText.destroy();
					comboSpr.destroy();
					if (currentTimingShown != null && timeShown >= 20)
					{
						remove(currentTimingShown);
						currentTimingShown = null;
					}
					rating.destroy();
				},
				startDelay: Conductor.crochet * 0.001
			});
	
			curSection += 1;
			}
		}

	public function NearlyEquals(value1:Float, value2:Float, unimportantDifference:Float = 10):Bool
		{
			return Math.abs(FlxMath.roundDecimal(value1, 1) - FlxMath.roundDecimal(value2, 1)) < unimportantDifference;
		}

		var upHold:Bool = false;
		var downHold:Bool = false;
		var rightHold:Bool = false;
		var leftHold:Bool = false;	

		// THIS FUNCTION JUST FUCKS WIT HELD NOTES AND BOTPLAY/REPLAY (also gamepad shit)

		private function keyShit():Void // I've invested in emma stocks
			{
				// control arrays, order L D R U
				var holdArray:Array<Bool> = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
				var pressArray:Array<Bool> = [
					controls.LEFT_P,
					controls.DOWN_P,
					controls.UP_P,
					controls.RIGHT_P
				];
				var releaseArray:Array<Bool> = [
					controls.LEFT_R,
					controls.DOWN_R,
					controls.UP_R,
					controls.RIGHT_R
				];
				#if windows
				if (luaModchart != null){
				if (controls.LEFT_P){luaModchart.executeState('keyPressed',["left"]);};
				if (controls.DOWN_P){luaModchart.executeState('keyPressed',["down"]);};
				if (controls.UP_P){luaModchart.executeState('keyPressed',["up"]);};
				if (controls.RIGHT_P){luaModchart.executeState('keyPressed',["right"]);};
				};
				#end
		 
				
				// Prevent player input if botplay is on
				if(PlayStateChangeables.botPlay)
				{
					holdArray = [false, false, false, false];
					pressArray = [false, false, false, false];
					releaseArray = [false, false, false, false];
				} 

				var anas:Array<Ana> = [null,null,null,null];

				for (i in 0...pressArray.length)
					if (pressArray[i])
						anas[i] = new Ana(Conductor.songPosition, null, false, "miss", i);

				// HOLDS, check for sustain notes
				if (holdArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
				{
					notes.forEachAlive(function(daNote:Note)
					{
						if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && holdArray[daNote.noteData])
							goodNoteHit(daNote);
					});
				}
		 
				if (KeyBinds.gamepad && !FlxG.keys.justPressed.ANY)
				{
					// PRESSES, check for note hits
					if (pressArray.contains(true) && generatedMusic)
					{
						boyfriend.holdTimer = 0;
			
						var possibleNotes:Array<Note> = []; // notes that can be hit
						var directionList:Array<Int> = []; // directions that can be hit
						var dumbNotes:Array<Note> = []; // notes to kill later
						var directionsAccounted:Array<Bool> = [false,false,false,false]; // we don't want to do judgments for more than one presses
						
						notes.forEachAlive(function(daNote:Note)
							{
								if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit && !directionsAccounted[daNote.noteData])
								{
									if (directionList.contains(daNote.noteData))
										{
											directionsAccounted[daNote.noteData] = true;
											for (coolNote in possibleNotes)
											{
												if (coolNote.noteData == daNote.noteData && Math.abs(daNote.strumTime - coolNote.strumTime) < 10)
												{ // if it's the same note twice at < 10ms distance, just delete it
													// EXCEPT u cant delete it in this loop cuz it fucks with the collection lol
													dumbNotes.push(daNote);
													break;
												}
												else if (coolNote.noteData == daNote.noteData && daNote.strumTime < coolNote.strumTime)
												{ // if daNote is earlier than existing note (coolNote), replace
													possibleNotes.remove(coolNote);
													possibleNotes.push(daNote);
													break;
												}
											}
										}
										else
										{
											possibleNotes.push(daNote);
											directionList.push(daNote.noteData);
										}
								}
						});

						for (note in dumbNotes)
						{
							FlxG.log.add("killing dumb ass note at " + note.strumTime);
							note.kill();
							notes.remove(note, true);
							note.destroy();
						}
			
						possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
						if (perfectMode)
							goodNoteHit(possibleNotes[0]);
						else if (possibleNotes.length > 0)
						{
							if (!FlxG.save.data.ghost)
							{
								for (shit in 0...pressArray.length)
									{ // if a direction is hit that shouldn't be
										if (pressArray[shit] && !directionList.contains(shit))
											noteMiss(shit, null);
									}
							}
							for (coolNote in possibleNotes)
							{
								if (pressArray[coolNote.noteData])
								{
									if (mashViolations != 0)
										mashViolations--;
									scoreTxt.color = FlxColor.WHITE;
									var noteDiff:Float = -(coolNote.strumTime - Conductor.songPosition);
									anas[coolNote.noteData].hit = true;
									anas[coolNote.noteData].hitJudge = Ratings.CalculateRating(noteDiff, Math.floor((PlayStateChangeables.safeFrames / 60) * 1000));
									anas[coolNote.noteData].nearestNote = [coolNote.strumTime,coolNote.noteData,coolNote.sustainLength];
									goodNoteHit(coolNote);
								}
							}
						}
						else if (!FlxG.save.data.ghost)
							{
								for (shit in 0...pressArray.length)
									if (pressArray[shit])
										noteMiss(shit, null);
							}
					}

					if (!loadRep)
						for (i in anas)
							if (i != null)
								replayAna.anaArray.push(i); // put em all there
				}
				notes.forEachAlive(function(daNote:Note)
				{
					if(PlayStateChangeables.useDownscroll && daNote.y > strumLine.y ||
					!PlayStateChangeables.useDownscroll && daNote.y < strumLine.y)
					{
						// Force good note hit regardless if it's too late to hit it or not as a fail safe
						if(PlayStateChangeables.botPlay && daNote.canBeHit && daNote.mustPress ||
						PlayStateChangeables.botPlay && daNote.tooLate && daNote.mustPress)
						{
							if(loadRep)
							{
								//trace('ReplayNote ' + tmpRepNote.strumtime + ' | ' + tmpRepNote.direction);
								var n = findByTime(daNote.strumTime);
								trace(n);
								if(n != null)
								{
									goodNoteHit(daNote);
									boyfriend.holdTimer = daNote.sustainLength;
								}
							}else {
								goodNoteHit(daNote);
								boyfriend.holdTimer = daNote.sustainLength;
							}
						}
					}
				});
				
				if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && (!holdArray.contains(true) || PlayStateChangeables.botPlay))
				{
					if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
						boyfriend.playAnim('idle');
				}
		 
				playerStrums.forEach(function(spr:FlxSprite)
				{
					if (pressArray[spr.ID] && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (!holdArray[spr.ID])
						spr.animation.play('static');
		 
					if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
					{
						spr.centerOffsets();
						spr.offset.x -= 13;
						spr.offset.y -= 13;
					}
					else
						spr.centerOffsets();
				});
			}

			public function findByTime(time:Float):Array<Dynamic>
				{
					for (i in rep.replay.songNotes)
					{
						//trace('checking ' + Math.round(i[0]) + ' against ' + Math.round(time));
						if (i[0] == time)
							return i;
					}
					return null;
				}

			public function findByTimeIndex(time:Float):Int
				{
					for (i in 0...rep.replay.songNotes.length)
					{
						//trace('checking ' + Math.round(i[0]) + ' against ' + Math.round(time));
						if (rep.replay.songNotes[i][0] == time)
							return i;
					}
					return -1;
				}

			public var fuckingVolume:Float = 1;
			public var useVideo = false;

			public static var webmHandler:WebmHandler;

			public var playingDathing = false;

			public var videoSprite:FlxSprite;

			public function focusOut() {
				if (paused)
					return;
				persistentUpdate = false;
				persistentDraw = true;
				paused = true;
		
					if (FlxG.sound.music != null)
					{
						FlxG.sound.music.pause();
						vocals.pause();
					}
		
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
			}
			public function focusIn() 
			{ 
				// nada 
			}


			public function backgroundVideo(source:String) // for background videos
				{
					#if cpp
					useVideo = true;
			
					FlxG.stage.window.onFocusOut.add(focusOut);
					FlxG.stage.window.onFocusIn.add(focusIn);

					var ourSource:String = "assets/videos/daWeirdVid/dontDelete.webm";
					WebmPlayer.SKIP_STEP_LIMIT = 90;
					var str1:String = "WEBM SHIT"; 
					webmHandler = new WebmHandler();
					webmHandler.source(ourSource);
					webmHandler.makePlayer();
					webmHandler.webm.name = str1;
			
					GlobalVideo.setWebm(webmHandler);

					GlobalVideo.get().source(source);
					GlobalVideo.get().clearPause();
					if (GlobalVideo.isWebm)
					{
						GlobalVideo.get().updatePlayer();
					}
					GlobalVideo.get().show();
			
					if (GlobalVideo.isWebm)
					{
						GlobalVideo.get().restart();
					} else {
						GlobalVideo.get().play();
					}
					
					var data = webmHandler.webm.bitmapData;
			
					videoSprite = new FlxSprite(-470,-30).loadGraphic(data);
			
					videoSprite.setGraphicSize(Std.int(videoSprite.width * 1.2));
			
					remove(gf);
					remove(boyfriend);
					remove(dad);
					add(videoSprite);
					add(gf);
					add(boyfriend);
					add(dad);
			
					trace('poggers');
			
					if (!songStarted)
						webmHandler.pause();
					else
						webmHandler.resume();
					#end
				}

	function noteMiss(direction:Int = 1, daNote:Note):Void
	{
		if (!boyfriend.stunned)
		{
			health -= 0.04;
			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;
			misses++;

			if (daNote != null)
			{
				if (!loadRep)
				{
					saveNotes.push([daNote.strumTime,0,direction,166 * Math.floor((PlayState.rep.replay.sf / 60) * 1000) / 166]);
					saveJudge.push("miss");
				}
			}
			else
				if (!loadRep)
				{
					saveNotes.push([Conductor.songPosition,0,direction,166 * Math.floor((PlayState.rep.replay.sf / 60) * 1000) / 166]);
					saveJudge.push("miss");
				}

			//var noteDiff:Float = Math.abs(daNote.strumTime - Conductor.songPosition);
			//var wife:Float = EtternaFunctions.wife3(noteDiff, FlxG.save.data.etternaMode ? 1 : 1.7);

			if (FlxG.save.data.accuracyMod == 1)
				totalNotesHit -= 1;

			songScore -= 10;

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');

			switch (direction)
			{
				case 0:
					boyfriend.playAnim('singLEFTmiss', true);
				case 1:
					boyfriend.playAnim('singDOWNmiss', true);
				case 2:
					boyfriend.playAnim('singUPmiss', true);
				case 3:
					boyfriend.playAnim('singRIGHTmiss', true);
			}

			#if windows
			if (luaModchart != null)
				luaModchart.executeState('playerOneMiss', [direction, Conductor.songPosition]);
			#end


			updateAccuracy();
		}
	}

	/*function badNoteCheck()
		{
			// just double pasting this shit cuz fuk u
			// REDO THIS SYSTEM!
			var upP = controls.UP_P;
			var rightP = controls.RIGHT_P;
			var downP = controls.DOWN_P;
			var leftP = controls.LEFT_P;
	
			if (leftP)
				noteMiss(0);
			if (upP)
				noteMiss(2);
			if (rightP)
				noteMiss(3);
			if (downP)
				noteMiss(1);
			updateAccuracy();
		}
	*/
	function updateAccuracy() 
		{
			totalPlayed += 1;
			accuracy = Math.max(0,totalNotesHit / totalPlayed * 100);
			accuracyDefault = Math.max(0, totalNotesHitDefault / totalPlayed * 100);
		}


	function getKeyPresses(note:Note):Int
	{
		var possibleNotes:Array<Note> = []; // copypasted but you already know that

		notes.forEachAlive(function(daNote:Note)
		{
			if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
			{
				possibleNotes.push(daNote);
				possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
			}
		});
		if (possibleNotes.length == 1)
			return possibleNotes.length + 1;
		return possibleNotes.length;
	}
	
	var mashing:Int = 0;
	var mashViolations:Int = 0;

	var etternaModeScore:Int = 0;

	function noteCheck(controlArray:Array<Bool>, note:Note):Void // sorry lol
		{
			var noteDiff:Float = -(note.strumTime - Conductor.songPosition);

			note.rating = Ratings.CalculateRating(noteDiff, Math.floor((PlayStateChangeables.safeFrames / 60) * 1000));

			/* if (loadRep)
			{
				if (controlArray[note.noteData])
					goodNoteHit(note, false);
				else if (rep.replay.keyPresses.length > repPresses && !controlArray[note.noteData])
				{
					if (NearlyEquals(note.strumTime,rep.replay.keyPresses[repPresses].time, 4))
					{
						goodNoteHit(note, false);
					}
				}
			} */
			
			if (controlArray[note.noteData])
			{
				goodNoteHit(note, (mashing > getKeyPresses(note)));
				
				/*if (mashing > getKeyPresses(note) && mashViolations <= 2)
				{
					mashViolations++;

					goodNoteHit(note, (mashing > getKeyPresses(note)));
				}
				else if (mashViolations > 2)
				{
					// this is bad but fuck you
					playerStrums.members[0].animation.play('static');
					playerStrums.members[1].animation.play('static');
					playerStrums.members[2].animation.play('static');
					playerStrums.members[3].animation.play('static');
					health -= 0.4;
					trace('mash ' + mashing);
					if (mashing != 0)
						mashing = 0;
				}
				else
					goodNoteHit(note, false);*/

			}
		}

		function goodNoteHit(note:Note, resetMashViolation = true):Void
			{

				if (mashing != 0)
					mashing = 0;

				var noteDiff:Float = -(note.strumTime - Conductor.songPosition);

				if(loadRep)
				{
					noteDiff = findByTime(note.strumTime)[3];
					note.rating = rep.replay.songJudgements[findByTimeIndex(note.strumTime)];
				}
				else
					note.rating = Ratings.CalculateRating(noteDiff);

				if (note.rating == "miss")
					return;	

				// add newest note to front of notesHitArray
				// the oldest notes are at the end and are removed first
				if (!note.isSustainNote)
					notesHitArray.unshift(Date.now());

				if (!resetMashViolation && mashViolations >= 1)
					mashViolations--;

				if (mashViolations < 0)
					mashViolations = 0;

				if (!note.wasGoodHit)
				{
					if (!note.isSustainNote)
					{
						popUpScore(note);
						combo += 1;
					}
					else
						totalNotesHit += 1;
	

					switch (note.noteData)
					{
						case 2:
							boyfriend.playAnim('singUP', true);
						case 3:
							boyfriend.playAnim('singRIGHT', true);
						case 1:
							boyfriend.playAnim('singDOWN', true);
						case 0:
							boyfriend.playAnim('singLEFT', true);
					}
		
					#if windows
					if (luaModchart != null)
						luaModchart.executeState('playerOneSing', [note.noteData, Conductor.songPosition]);
					#end


					if(!loadRep && note.mustPress)
					{
						var array = [note.strumTime,note.sustainLength,note.noteData,noteDiff];
						if (note.isSustainNote)
							array[1] = -1;
						saveNotes.push(array);
						saveJudge.push(note.rating);
					}
					
					playerStrums.forEach(function(spr:FlxSprite)
					{
						if (Math.abs(note.noteData) == spr.ID)
						{
							spr.animation.play('confirm', true);
						}
					});
					
					note.wasGoodHit = true;
					vocals.volume = 1;
		
					note.kill();
					notes.remove(note, true);
					note.destroy();
					
					updateAccuracy();
				}
			}
		
	function moveTank(){
		if(!inCutscene){
			tankAngle += FlxG.elapsed * tankSpeed;
			tankRolling.angle = tankAngle - 90 + 15;
			tankRolling.x = tankX + 1500 * Math.cos(Math.PI / 180 * (1 * tankAngle + 180));
			tankRolling.y = 1300 + 1100 * Math.sin(Math.PI / 180 * (1 * tankAngle + 180));
		}

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		if(FlxG.save.data.distractions){
			fastCar.x = -12600;
			fastCar.y = FlxG.random.int(140, 250);
			fastCar.velocity.x = 0;
			fastCarCanDrive = true;
		}
	}

	function fastCarDrive()
	{
		if(FlxG.save.data.distractions){
			FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

			fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
			fastCarCanDrive = false;
			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				resetFastCar();
			});
		}
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		if(FlxG.save.data.distractions){
			trainMoving = true;
			if (!trainSound.playing)
				trainSound.play(true);
		}
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if(FlxG.save.data.distractions){
			if (trainSound.time >= 4700)
				{
					startedMoving = true;
					gf.playAnim('hairBlow');
				}
		
				if (startedMoving)
				{
					phillyTrain.x -= 400;
		
					if (phillyTrain.x < -2000 && !trainFinishing)
					{
						phillyTrain.x = -1150;
						trainCars -= 1;
		
						if (trainCars <= 0)
							trainFinishing = true;
					}
		
					if (phillyTrain.x < -4000 && trainFinishing)
						trainReset();
				}
		}

	}

	function trainReset():Void
	{
		if(FlxG.save.data.distractions){
			gf.playAnim('hairFall');
			phillyTrain.x = FlxG.width + 200;
			trainMoving = false;
			// trainSound.stop();
			// trainSound.time = 0;
			trainCars = 8;
			trainFinishing = false;
			startedMoving = false;
		}
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);
	}

	var danced:Bool = false;

	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		if (dad.curCharacter == 'tankman' && SONG.song.toLowerCase() == 'stress')
		{
			if (curStep == 735)
			{
				dad.addOffset("singDOWN", 45, 20);
				dad.animation.getByName('singDOWN').frames = dad.animation.getByName('prettyGoodAnim').frames;
				dad.playAnim('prettyGoodAnim', true);
			}

			if (curStep == 736 || curStep == 737)
			{
				
				dad.playAnim('prettyGoodAnim', true);
			}

			if (curStep == 767)
			{
				dad.addOffset("singDOWN", 98, -90);
				dad.animation.getByName('singDOWN').frames = dad.animation.getByName('oldSingDOWN').frames;
			}
		}

		//picoSpeaker and running tankmen

		if(SONG.song.toLowerCase() == 'stress')
		{
			//RIGHT

			if (curStep == 2 || 
				curStep == 3 || 
				curStep == 5 || 
				curStep == 9 || 
				curStep == 10 || 
				curStep == 16 || 
				curStep == 22 || 
				curStep == 25 || 
				curStep == 26 || 
				curStep == 34 || 
				curStep == 35 || 
				curStep == 37 || 
				curStep == 41 || 
				curStep == 42 || 
				curStep == 48 || 
				curStep == 54 || 
				curStep == 57 || 
				curStep == 58 || 
				curStep == 66 || 
				curStep == 67 || 
				curStep == 69 || 
				curStep == 73 || 
				curStep == 74 || 
				curStep == 80 || 
				curStep == 86 || 
				curStep == 89 || 
				curStep == 90 || 
				curStep == 98 || 
				curStep == 99 || 
				curStep == 101 || 
				curStep == 105 ||
				 curStep == 106 || 
				 curStep == 112 || 
				 curStep == 118 || 
				 curStep == 121 || 
				 curStep == 122 || 
				 curStep == 253 || 
				 curStep == 260 || 
				 curStep == 268 || 
				 curStep == 280 || 
				 curStep == 284 || 
				 curStep == 292 || 
				 curStep == 300 || 
				 curStep == 312 || 
				 curStep == 316 || 
				 curStep == 317 || 
				 curStep == 318 || 
				 curStep == 320 || 
				 curStep == 332 || 
				 curStep == 336 || 
				 curStep == 344 || 
				 curStep == 358 || 
				 curStep == 360 || 
				 curStep == 362 || 
				 curStep == 364 || 
				 curStep == 372 || 
				 curStep == 376 || 
				 curStep == 388 || 
				 curStep == 396 || 
				 curStep == 404 || 
				 curStep == 408 || 
				 curStep == 412 || 
				 curStep == 420 || 
				 curStep == 428 || 
				 curStep == 436 || 
				 curStep == 440 || 
				 curStep == 444 || 
				 curStep == 452 || 
				 curStep == 456 || 
				 curStep == 460 || 
				 curStep == 468 || 
				 curStep == 472 || 
				 curStep == 476 || 
				 curStep == 484 || 
				 curStep == 488 || 
				 curStep == 492 || 
				 curStep == 508 || 
				 curStep == 509 || 
				 curStep == 510 || 
				 curStep == 516 || 
				 curStep == 520 || 
				 curStep == 524 || 
				 curStep == 532 || 
				 curStep == 540 || 
				 curStep == 552 || 
				 curStep == 556 || 
				 curStep == 564 || 
				 curStep == 568 || 
				 curStep == 572 || 
				 curStep == 580 || 
				 curStep == 584 || 
				 curStep == 588 || 
				 curStep == 596 || 
				 curStep == 604 || 
				 curStep == 612 || 
				 curStep == 616 || 
				 curStep == 620 || 
				 curStep == 636 || 
				 curStep == 637 || 
				 curStep == 638 || 
				 curStep == 642 || 
				 curStep == 643 || 
				 curStep == 645 || 
				 curStep == 649 || 
				 curStep == 650 || 
				 curStep == 656 || 
				 curStep == 662 || 
				 curStep == 665 || 
				 curStep == 666 || 
				 curStep == 674 || 
				 curStep == 675 || 
				 curStep == 677 || 
				 curStep == 681 || 
				 curStep == 682 || 
				 curStep == 688 || 
				 curStep == 694 || 
				 curStep == 697 || 
				 curStep == 698 || 
				 curStep == 706 || 
				 curStep == 707 || 
				 curStep == 709 || 
				 curStep == 713 || 
				 curStep == 714 || 
				 curStep == 720 || 
				 curStep == 726 || 
				 curStep == 729 || 
				 curStep == 730 || 
				 curStep == 738 || 
				 curStep == 739 || 
				 curStep == 741 || 
				 curStep == 745 || 
				 curStep == 746 || 
				 curStep == 753 || 
				 curStep == 758 || 
				 curStep == 761 || 
				 curStep == 762 || 
				 curStep == 768 || 
				 curStep == 788 || 
				 curStep == 792 || 
				 curStep == 796 || 
				 curStep == 800 || 
				 curStep == 820 || 
				 curStep == 824 || 
				 curStep == 828 || 
				 curStep == 829 || 
				 curStep == 830 || 
				 curStep == 832 || 
				 curStep == 852 || 
				 curStep == 856 || 
				 curStep == 860 || 
				 curStep == 861 || 
				 curStep == 862 || 
				 curStep == 864 || 
				 curStep == 865 || 
				 curStep == 866 || 
				 curStep == 884 || 
				 curStep == 885 || 
				 curStep == 886 || 
				 curStep == 887 || 
				 curStep == 892 || 
				 curStep == 900 || 
				 curStep == 912 || 
				 curStep == 916 || 
				 curStep == 924 || 
				 curStep == 926 || 
				 curStep == 936 || 
				 curStep == 948 || 
				 curStep == 958 || 
				 curStep == 962 || 
				 curStep == 966 || 
				 curStep == 970 || 
				 curStep == 974 || 
				 curStep == 976 || 
				 curStep == 980 || 
				 curStep == 984 || 
				 curStep == 988 || 
				 curStep == 990 || 
				 curStep == 1000 || 
				 curStep == 1004 || 
				 curStep == 1006 || 
				 curStep == 1008 || 
				 curStep == 1012 || 
				 curStep == 1019 || 
				 curStep == 1028 || 
				 curStep == 1036 || 
				 curStep == 1044 || 
				 curStep == 1052|| 
				 curStep == 1060 || 
				 curStep == 1068 || 
				 curStep == 1076 || 
				 curStep == 1084 || 
				 curStep == 1092 || 
				 curStep == 1100 || 
				 curStep == 1108 || 
				 curStep == 1116 || 
				 curStep == 1124 || 
				 curStep == 1132 || 
				 curStep == 1148 || 
				 curStep == 1149 || 
				 curStep == 1150 || 
				 curStep == 1156 || 
				 curStep == 1160 || 
				 curStep == 1164 || 
				 curStep == 1172 || 
				 curStep == 1180 || 
				 curStep == 1188 || 
				 curStep == 1192 || 
				 curStep == 1196 || 
				 curStep == 1204 || 
				 curStep == 1208 || 
				 curStep == 1212 || 
				 curStep == 1220 || 
				 curStep == 1224 || 
				 curStep == 1228 || 
				 curStep == 1236 || 
				 curStep == 1244 || 
				 curStep == 1252 || 
				 curStep == 1256 || 
				 curStep == 1260 || 
				 curStep == 1276 || 
				 curStep == 1296 || 
				 curStep == 1300 || 
				 curStep == 1304 || 
				 curStep == 1308 || 
				 curStep == 1320 || 
				 curStep == 1324 || 
				 curStep == 1328 || 
				 curStep == 1332 || 
				 curStep == 1340 || 
				 curStep == 1352 || 
				 curStep == 1358 || 
				 curStep == 1364 || 
				 curStep == 1372 || 
				 curStep == 1374 || 
				 curStep == 1378 || 
				 curStep == 1388 || 
				 curStep == 1392 || 
				 curStep == 1400 || 
				 curStep == 1401 || 
				 curStep == 1405 || 
				 curStep == 1410 || 
				 curStep == 1411 || 
				 curStep == 1413 || 
				 curStep == 1417 || 
				 curStep == 1418 || 
				 curStep == 1424 || 
				 curStep == 1430 || 
				 curStep == 1433 || 
				 curStep == 1434)
				 
			{
				gf.playAnim('shoot' + FlxG.random.int(1, 2), true);
				
				var tankmanRunner:TankmenBG = new TankmenBG();
			}

			//LEFT
			if (curStep == 0 || 
				curStep == 7 || 
				curStep == 12 || 
				curStep == 14 || 
				curStep == 15 || 
				curStep == 18 || 
				curStep == 19 || 
				curStep == 24 || 
				curStep == 28 || 
				curStep == 32 || 
				curStep == 39 || 
				curStep == 44 || 
				curStep == 46 || 
				curStep == 47 || 
				curStep == 50 || 
				curStep == 51 || 
				curStep == 56 || 
				curStep == 60 || 
				curStep == 61 || 
				curStep == 62 || 
				curStep == 64 || 
				curStep == 71 || 
				curStep == 76 || 
				curStep == 78 || 
				curStep == 79 || 
				curStep == 82 || 
				curStep == 83 || 
				curStep == 88 || 
				curStep == 92 || 
				curStep == 96 || 
				curStep == 103 ||
				 curStep == 108 || 
				 curStep == 110 || 
				 curStep == 111 || 
				 curStep == 114 || 
				 curStep == 115 || 
				 curStep == 120 || 
				 curStep == 124 || 
				 curStep == 252 || 
				 curStep == 254 || 
				 curStep == 256 || 
				 curStep == 264 || 
				 curStep == 272 || 
				 curStep == 276 || 
				 curStep == 288 || 
				 curStep == 296 || 
				 curStep == 304 || 
				 curStep == 308 || 
				 curStep == 324 || 
				 curStep == 328 || 
				 curStep == 340 || 
				 curStep == 348 || 
				 curStep == 352 || 
				 curStep == 354 || 
				 curStep == 356 || 
				 curStep == 366 || 
				 curStep == 368 || 
				 curStep == 378 || 
				 curStep == 384 || 
				 curStep == 392 || 
				 curStep == 394 || 
				 curStep == 400 || 
				 curStep == 410 || 
				 curStep == 416 || 
				 curStep == 424 || 
				 curStep == 426 || 
				 curStep == 432 || 
				 curStep == 442 || 
				 curStep == 448 || 
				 curStep == 458 || 
				 curStep == 464 || 
				 curStep == 474 || 
				 curStep == 480 || 
				 curStep == 490 || 
				 curStep == 496 || 
				 curStep == 500 || 
				 curStep == 504 || 
				 curStep == 506 || 
				 curStep == 512 || 
				 curStep == 522 || 
				 curStep == 528 || 
				 curStep == 536 || 
				 curStep == 538 || 
				 curStep == 544 || 
				 curStep == 554 || 
				 curStep == 560 || 
				 curStep == 570 || 
				 curStep == 576 || 
				 curStep == 586 || 
				 curStep == 592 || 
				 curStep == 600 || 
				 curStep == 602 || 
				 curStep == 608 || 
				 curStep == 618 || 
				 curStep == 624 || 
				 curStep == 628 || 
				 curStep == 632 || 
				 curStep == 634 || 
				 curStep == 640 || 
				 curStep == 647 || 
				 curStep == 652 || 
				 curStep == 654 || 
				 curStep == 655 || 
				 curStep == 658 || 
				 curStep == 659 || 
				 curStep == 664 || 
				 curStep == 668 || 
				 curStep == 672 || 
				 curStep == 679 || 
				 curStep == 684 || 
				 curStep == 686 || 
				 curStep == 687 || 
				 curStep == 690 || 
				 curStep == 691 || 
				 curStep == 696 || 
				 curStep == 700 || 
				 curStep == 701 || 
				 curStep == 702 || 
				 curStep == 704 || 
				 curStep == 711 || 
				 curStep == 716 || 
				 curStep == 718 || 
				 curStep == 719 || 
				 curStep == 722 || 
				 curStep == 723 || 
				 curStep == 728 || 
				 curStep == 732 || 
				 curStep == 736 || 
				 curStep == 743 || 
				 curStep == 748 || 
				 curStep == 750 || 
				 curStep == 751 || 
				 curStep == 754 || 
				 curStep == 755 || 
				 curStep == 760 || 
				 curStep == 764 || 
				 curStep == 772 || 
				 curStep == 776 || 
				 curStep == 780 || 
				 curStep == 784 || 
				 curStep == 804 || 
				 curStep == 808 || 
				 curStep == 812 || 
				 curStep == 816 || 
				 curStep == 836 || 
				 curStep == 840 || 
				 curStep == 844 || 
				 curStep == 848 || 
				 curStep == 868 || 
				 curStep == 869 || 
				 curStep == 870 || 
				 curStep == 872 || 
				 curStep == 873 || 
				 curStep == 874 || 
				 curStep == 876 || 
				 curStep == 877 || 
				 curStep == 878 || 
				 curStep == 880 || 
				 curStep == 881 || 
				 curStep == 882 || 
				 curStep == 883 || 
				 curStep == 888 || 
				 curStep == 889 || 
				 curStep == 890 || 
				 curStep == 891 || 
				 curStep == 896 || 
				 curStep == 904 || 
				 curStep == 908 || 
				 curStep == 920 || 
				 curStep == 928 || 
				 curStep == 932 || 
				 curStep == 940 || 
				 curStep == 944 || 
				 curStep == 951 || 
				 curStep == 952 || 
				 curStep == 953 || 
				 curStep == 955 || 
				 curStep == 960 || 
				 curStep == 964 || 
				 curStep == 968 || 
				 curStep == 972 || 
				 curStep == 978 || 
				 curStep == 982 || 
				 curStep == 986 || 
				 curStep == 992 || 
				 curStep == 994 || 
				 curStep == 996 || 
				 curStep == 1016 || 
				 curStep == 1017 || 
				 curStep == 1021 || 
				 curStep == 1024 || 
				 curStep == 1034 || 
				 curStep == 1040 || 
				 curStep == 1050 || 
				 curStep == 1056 || 
				 curStep == 1066 || 
				 curStep == 1072 || 
				 curStep == 1082 || 
				 curStep == 1088 || 
				 curStep == 1098 || 
				 curStep == 1104 || 
				 curStep == 1114 || 
				 curStep == 1120 || 
				 curStep == 1130 || 
				 curStep == 1136 || 
				 curStep == 1140 || 
				 curStep == 1144 || 
				 curStep == 1146 || 
				 curStep == 1152 || 
				 curStep == 1162 || 
				 curStep == 1168 || 
				 curStep == 1176 || 
				 curStep == 1178 || 
				 curStep == 1184 || 
				 curStep == 1194 || 
				 curStep == 1200 || 
				 curStep == 1210 || 
				 curStep == 1216 || 
				 curStep == 1226 || 
				 curStep == 1232 || 
				 curStep == 1240 || 
				 curStep == 1242 || 
				 curStep == 1248 || 
				 curStep == 1258 || 
				 curStep == 1264 || 
				 curStep == 1268 || 
				 curStep == 1272 || 
				 curStep == 1280 || 
				 curStep == 1284 || 
				 curStep == 1288 || 
				 curStep == 1292 || 
				 curStep == 1312 || 
				 curStep == 1314 || 
				 curStep == 1316 || 
				 curStep == 1336 || 
				 curStep == 1344 || 
				 curStep == 1356 || 
				 curStep == 1360 || 
				 curStep == 1368 || 
				 curStep == 1376 || 
				 curStep == 1380 || 
				 curStep == 1384 || 
				 curStep == 1396 || 
				 curStep == 1404 || 
				 curStep == 1408 || 
				 curStep == 1415 || 
				 curStep == 1420 || 
				 curStep == 1422 || 
				 curStep == 1423 || 
				 curStep == 1426 || 
				 curStep == 1427 || 
				 curStep == 1432 || 
				 curStep == 1436 || 
				 curStep == 1437 || 
				 curStep == 1438)
			{
				gf.playAnim('shoot' + FlxG.random.int(3, 4), true);

			}

			//Left spawn

			if (curStep == 2 || 
				
				curStep == 9 || 
				
				curStep == 22 || 
				
				curStep == 34 || 
				
				curStep == 41 || 
				
				curStep == 54 || 
				
				curStep == 66 || 
				 
				curStep == 73 || 
				
				curStep == 86 || 
				
				curStep == 98 || 
				
				curStep == 105 ||
				  
				 curStep == 118 || 
				 
				 curStep == 253 || 
				  
				 curStep == 280 || 
				 
				 curStep == 300 || 
				 
				 curStep == 317 || 
				  
				 curStep == 332 || 
				  
				 curStep == 358 || 
				  
				 curStep == 364 || 
				  
				 curStep == 388 || 
				 
				 curStep == 408 || 
				  
				 curStep == 428 || 
				  
				 curStep == 444 || 
				  
				 curStep == 460 || 
				 
				 curStep == 476 || 
				 
				 curStep == 492 || 
				  
				 curStep == 510 || 
				 
				 curStep == 524 || 
				  
				 curStep == 552 || 
				 
				 curStep == 568 || 
				  
				 curStep == 584 || 
				  
				 curStep == 604 || 
				 
				 curStep == 620 || 
				 
				 curStep == 638 || 
				 
				 curStep == 645 || 
				  
				 curStep == 656 || 
				 
				 curStep == 666 || 
				  
				 curStep == 677 || 
				  
				 curStep == 688 || 
				 
				 curStep == 698 || 
				  
				 curStep == 709 || 
				 
				 curStep == 720 || 
				  
				 curStep == 730 || 
				 
				 curStep == 741 || 
				  
				 curStep == 753 || 
				 
				 curStep == 762 || 
				 
				 curStep == 792 || 
				 
				 curStep == 820 || 
				  
				 curStep == 829 || 
				 
				 curStep == 852 || 
				  
				 curStep == 861 || 
				 
				 curStep == 865 || 
				 
				 curStep == 885 || 
				 
				 curStep == 892 || 
				  
				 curStep == 916 || 
				  
				 curStep == 936 || 
				 
				 curStep == 962 || 
				 
				 curStep == 974 || 
				 
				 curStep == 984 || 
				 
				 curStep == 1000 || 
				 
				 curStep == 1008 || 
				  
				 curStep == 1028 || 
				 
				 curStep == 1052|| 
				 
				 curStep == 1076 || 
				 
				 curStep == 1100 || 
				  
				 curStep == 1124 || 
				  
				 curStep == 1149 || 
				 
				 curStep == 1160 || 
				 
				 curStep == 1180 
				  
				 
				 )
				 
			{
				var tankmanRunner:TankmenBG = new TankmenBG();
				tankmanRunner.resetShit(FlxG.random.int(630, 730) * -1, 265, true, 1, 1.5);

				tankmanRun.add(tankmanRunner);
			}

			//Right spawn
			if (curStep == 0 || 
				
				curStep == 14 || 
				
				curStep == 19 || 
				
				curStep == 32 || 
				
				curStep == 46 || 
				
				curStep == 51 || 
				
				curStep == 61 || 
				 
				curStep == 71 || 
				
				curStep == 79 || 
				
				curStep == 88 || 
				
				curStep == 103 ||
				  
				 curStep == 111 || 
				 
				 curStep == 120 || 
				 
				 curStep == 254 || 
				 
				 curStep == 272 || 
				 
				 curStep == 296 || 
				  
				 curStep == 324 || 
				 
				 curStep == 348 || 
				 
				 curStep == 356 || 
				 
				 curStep == 378 || 
				  
				 curStep == 394 || 
				 
				 curStep == 416 || 
				  
				 curStep == 432 || 
				 
				 curStep == 458 || 
				 
				 curStep == 480 || 
				 
				 curStep == 500 || 
				 
				 curStep == 512 || 
				 
				 curStep == 536 || 
				 
				 curStep == 554 || 
				  
				 curStep == 576 || 
				 
				 curStep == 600 || 
				 
				 curStep == 618 || 
				  
				 curStep == 632 || 
				 
				 curStep == 647 || 
				 
				 curStep == 655 || 
				 
				 curStep == 664 || 
				 
				 curStep == 679 || 
				 
				 curStep == 687 || 
				 
				 curStep == 696 || 
				 
				 curStep == 702 || 
				 
				 curStep == 716 || 
				 
				 curStep == 722 || 
				 
				 curStep == 732 || 
				 
				 curStep == 748 || 
				 
				 curStep == 754 || 
				 
				 curStep == 764 || 
				 
				 curStep == 780 || 
				 
				 curStep == 808 || 
				 
				 curStep == 836 || 
				 
				 curStep == 848 || 
				 
				 curStep == 870 || 
				 
				 curStep == 874 || 
				 
				 curStep == 878 || 
				 
				 curStep == 882 || 
				 
				 curStep == 889 || 
				 
				 curStep == 896 || 
				 
				 curStep == 920 || 
				 
				 curStep == 940 || 
				 
				 curStep == 952 || 
				 
				 curStep == 960 || 
				 
				 curStep == 972 || 
				 
				 curStep == 986 || 
				 
				 curStep == 996 || 
				 
				 curStep == 1021 || 
				 
				 curStep == 1040 || 
				 
				 curStep == 1066 || 
				 
				 curStep == 1088 || 
				 
				 curStep == 1114 || 
				 
				 curStep == 1136 || 
				 
				 curStep == 1146 || 
				 
				 curStep == 1168 || 
				 
				 curStep == 1184
				
				 
				 )
			{
				var tankmanRunner:TankmenBG = new TankmenBG();
				tankmanRunner.resetShit(FlxG.random.int(1500, 1700) * 1, 285, false, 1, 1.5);
				tankmanRun.add(tankmanRunner);
			}
		}

		if (dad.curCharacter == 'tankman' && SONG.song.toLowerCase() == 'ugh')
		{
			
			if (curStep == 59 || curStep == 443 || curStep == 523 || curStep == 827) // -1
			{
				dad.addOffset("singUP", 45, 0);
				
				dad.animation.getByName('singUP').frames = dad.animation.getByName('ughAnim').frames;
			}

			if (curStep == 64 || curStep == 448 || curStep == 528 || curStep == 832) // +4
			{
				dad.addOffset("singUP", 24, 56);
				dad.animation.getByName('singUP').frames = dad.animation.getByName('oldSingUP').frames;
			}
		}

		if (curSong.toLowerCase() == 'tutorial remix' && curStep == 44)
		{
			startCountdown();
		}

		if (SONG.song == 'It\'s Been So Long' && curStep == 446 && dad.curCharacter == 'sarvente')
		{
			boyfriend.playAnim('hey', true);
			gf.playAnim('cheer', true);
			dad.playAnim('hey', true);
		}

		if (SONG.song == 'Zavodila Remix' && curStep >= 1713 && dad.curCharacter == 'ruv' && dad.animation.curAnim.name.startsWith('sing'))
		{
			camHUD.shake(0.1, 0.4);
			FlxG.camera.shake(0.1, 0.4);
			boyfriend.playAnim('idle', false);
			boyfriend.playAnim('shocked', true);
			gf.playAnim('dance', false);
			gf.playAnim('scared', true);
		}

		if (curSong == 'Church-Lords' && dad.curCharacter == 'sarvente')
		{
			switch (curStep)
			{
				case 316:
					remove(dad);
					dad = new Character(630, 554, 'ruv', false);
					iconP2.animation.play('ruv');
					add(dad);
			}
		}

		if (curSong == 'Church-Lords' && dad.curCharacter == 'ruv')
		{
			switch (curStep)
			{
				case 316:
					remove(dad);
					dad = new Character(630, 554, 'sarvente', false);
					iconP2.animation.play('sarvente');
					add(dad);
			}
		}

		if (curSong == 'Church-Lords' && dad.curCharacter == 'sarvente')
		{
			switch (curStep)
			{
				case 316:
					remove(dad);
					dad = new Character(630, 554, 'ruv', false);
					iconP2.animation.play('ruv');
					add(dad);
			}
		}

		if (curSong == 'Church-Lords' && dad.curCharacter == 'ruv')
		{
			switch (curStep)
			{
				case 316:
					remove(dad);
					dad = new Character(630, 554, 'sarvente', false);
					iconP2.animation.play('sarvente');
					add(dad);
			}
		}

		if (curSong == 'Church-Lords' && dad.curCharacter == 'sarvente')
		{
			switch (curStep)
			{
				case 316:
					remove(dad);
					dad = new Character(630, 554, 'ruv', false);
					iconP2.animation.play('ruv');
					add(dad);
			}
		}

		if (curSong == 'Church-Lords' && boyfriend.curCharacter == 'bf')
		{
			switch (curStep)
			{
				case 316:
					remove(boyfriend);
					boyfriend = new Boyfriend(630, 554, 'sarvente');
					iconP1.animation.play('sarvente');
					add(boyfriend);
			}
		}

		if (curSong == 'Church-Lords' && boyfriend.curCharacter == 'sarvente')
		{
			switch (curStep)
			{
				case 316:
					remove(dad);
					boyfriend = new Boyfriend(630, 554, 'bf');
					iconP1.animation.play('bf');
					add(boyfriend);
			}
		}

		if (curSong == 'Church-Lords' && dad.curCharacter == 'ruv')
		{
			switch (curStep)
			{
				case 316:
					remove(dad);
					dad = new Character(630, 554, 'sarvente', false);
					iconP2.animation.play('sarvente');
					add(dad);
			}
		}

		if (curSong == 'Church-Lords' && dad.curCharacter == 'sarvente')
		{
			switch (curStep)
			{
				case 316:
					remove(dad);
					dad = new Character(630, 554, 'ruv', false);
					iconP2.animation.play('ruv');
					add(dad);
			}
		}

		if (curSong == 'Church-Lords' && dad.curCharacter == 'ruv')
		{
			switch (curStep)
			{
				case 316:
					remove(dad);
					dad = new Character(630, 554, 'sarvente', false);
					iconP2.animation.play('sarvente');
					add(dad);
			}
		}

		if (curSong == 'Church-Lords' && dad.curCharacter == 'sarvente')
		{
			switch (curStep)
			{
				case 316:
					remove(dad);
					dad = new Character(630, 554, 'ruv', false);
					iconP2.animation.play('sarvente');
					add(dad);
			}
		}

		if (curSong == 'Ruvved Up' && dad.curCharacter == 'ruv')
		{
			switch (curStep)
			{
				case 316:
					remove(dad);
					dad = new Character(630, 554, 'sarvente', false);
					iconP2.animation.play('sarvente');
					add(dad);
			}
		}

		if (curSong == 'Ruvved Up' && dad.curCharacter == 'sarvente')
		{
			switch (curStep)
			{
				case 348:
					remove(dad);
					dad = new Character(630, 554, 'ruv', false);
					iconP2.animation.play('ruv');
					add(dad);
			}
		}

		if (curSong == 'Ruvved Up' && dad.curCharacter == 'ruv')
		{
			switch (curStep)
			{
				case 412:
					remove(dad);
					dad = new Character(630, 554, 'sarvente', false);
					iconP2.animation.play('sarvente');
					add(dad);
			}
		}

		if (curSong == 'Ruvved Up' && dad.curCharacter == 'sarvente')
		{
			switch (curStep)
			{
				case 476:
					remove(dad);
					dad = new Character(630, 554, 'ruv', false);
					iconP2.animation.play('ruv');
					add(dad);
			}
		}

		if (curSong == 'Ruvved Up' && dad.curCharacter == 'ruv')
		{
			switch (curStep)
			{
				case 540:
					remove(dad);
					dad = new Character(630, 554, 'sarvente', false);
					iconP2.animation.play('sarvente');
					add(dad);
			}
		}

		if (curSong == 'Ruvved Up' && dad.curCharacter == 'sarvente')
		{
			switch (curStep)
			{
				case 575:
					remove(dad);
					dad = new Character(630, 554, 'ruv', false);
					iconP2.animation.play('ruv');
					add(dad);
			}
		}

		if (curSong == 'Ruvved Up' && dad.curCharacter == 'ruv')
		{
			switch (curStep)
			{
				case 706:
					remove(dad);
					dad = new Character(630, 554, 'sarvente', false);
					iconP2.animation.play('sarvente');
					add(dad);
			}
		}

		if (curSong == 'Ruvved Up' && dad.curCharacter == 'sarvente')
		{
			switch (curStep)
			{
				case 924:
					remove(dad);
					dad = new Character(630, 554, 'ruv', false);
					iconP2.animation.play('ruv');
					add(dad);
			}
		}

		if (curSong == 'Ruvved Up' && dad.curCharacter == 'ruv')
		{
			switch (curStep)
			{
				case 988:
					remove(dad);
					dad = new Character(630, 554, 'sarvente', false);
					iconP2.animation.play('sarvente');
					add(dad);
			}
		}

		if (curSong == 'Ruvved Up' && dad.curCharacter == 'sarvente')
		{
			switch (curStep)
			{
				case 1052:
					remove(dad);
					dad = new Character(630, 554, 'ruv', false);
					iconP2.animation.play('ruv');
					add(dad);
			}
		}

		if (curSong == 'Ruvved Up' && dad.curCharacter == 'ruv')
		{
			switch (curStep)
			{
				case 1116:
					remove(dad);
					dad = new Character(630, 554, 'sarvente', false);
					iconP2.animation.play('sarvente');
					add(dad);
			}
		}

		#if windows
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curStep',curStep);
			luaModchart.executeState('stepHit',[curStep]);
		}
		#end

		// yes this updates every step.
		// yes this is bad
		// but i'm doing it to update misses and accuracy
		#if windows
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC,true,  songLength - Conductor.songPosition);
		#end

	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, (PlayStateChangeables.useDownscroll ? FlxSort.ASCENDING : FlxSort.DESCENDING));
		}

		#if windows
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curBeat',curBeat);
			luaModchart.executeState('beatHit',[curBeat]);
		}
		#end

		if (curSong == 'Tutorial' && dad.curCharacter == 'gf') {
			if (curBeat % 2 == 1 && dad.animOffsets.exists('danceLeft'))
				dad.playAnim('danceLeft');
			if (curBeat % 2 == 0 && dad.animOffsets.exists('danceRight'))
				dad.playAnim('danceRight');
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);

			// Dad doesnt interupt his own notes
			if (SONG.notes[Math.floor(curStep / 16)].mustHitSection && dad.curCharacter != 'gf')
				dad.dance();
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		if (FlxG.save.data.camzoom)
		{
			// HARDCODING FOR MILF ZOOMS!
			if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
			{
				FlxG.camera.zoom += 0.27;
				camHUD.zoom += 0.15;
			}

			if (curSong.toLowerCase() == 'stress' && curBeat >= 224 && curBeat < 254 && camZooming && FlxG.camera.zoom < 1.35)
			{
				FlxG.camera.zoom += 0.27;
				camHUD.zoom += 0.15;
			}

			if (curSong.toLowerCase() == 'stress' && curBeat >= 320 && curBeat < 352 && camZooming && FlxG.camera.zoom < 1.35)
			{
				FlxG.camera.zoom += 0.27;
				camHUD.zoom += 0.15;
			}
	
			if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
			{
				FlxG.camera.zoom += 0.045;
				camHUD.zoom += 0.09;
			}
	
		}

		iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		iconP2.setGraphicSize(Std.int(iconP2.width + 30));
			
		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0)
		{
			gf.dance();
		}

		if (!boyfriend.animation.curAnim.name.startsWith("sing"))
		{
			boyfriend.playAnim('idle');
		}
		
		if (!dad.animation.curAnim.name.startsWith("sing"))
		{
			dad.dance();
		}

		if (dad.curCharacter == 'ruv' && dad.animation.curAnim.name.startsWith('sing'))
		{
			camHUD.shake(0.0085, 0.4);
			FlxG.camera.shake(0.0085, 0.4);
			boyfriend.playAnim('idle', false);
			boyfriend.playAnim('scared', true);
			gf.playAnim('dance', false);
			gf.playAnim('scared', true);
		}

		if (dad.curCharacter == 'ruv-alt' && dad.animation.curAnim.name.startsWith('sing'))
		{
			camHUD.shake(0.0085, 0.4);
			FlxG.camera.shake(0.0085, 0.4);
		}

		if (boyfriend.curCharacter == 'ruv' && boyfriend.animation.curAnim.name.startsWith('sing'))
		{
			camHUD.shake(0.0085, 0.4);
			FlxG.camera.shake(0.0085, 0.4);
			gf.playAnim('dance', false);
			gf.playAnim('scared', true);
		}

		if (curBeat % 8 == 7 && curSong == 'Bopeebo')
		{
			boyfriend.playAnim('hey', true);
		}

		if (curBeat % 16 == 15 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48)
			{
				boyfriend.playAnim('hey', true);
				dad.playAnim('cheer', true);
			}

		if (boyfriend.animation.curAnim.name.startsWith('sing') || boyfriend.animation.curAnim.name == 'idle')
		{
			switch(curSong)
			{
				case 'Parish':
				{
					if(curBeat > 48 && curBeat != 64 && curBeat != 96 && curBeat != 128 && curBeat != 160 && curBeat < 176)
					{
						if(curBeat % 16 == 15)
						{
							if(!triggeredAlready)
							{
								boyfriend.playAnim('hey');
								triggeredAlready = true;
							}
						}else triggeredAlready = false;
					}
				}
			}
		}

		if (curBeat % 16 == 15 && SONG.song == 'Parish' && dad.curCharacter == 'sarvente' && curBeat > 32 && curBeat != 48 && curBeat != 80 && curBeat != 112 && curBeat != 144 && curBeat < 160)
			{
				dad.playAnim('hey', true);
			}

		if (curBeat % 16 == 15 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48)
			{
				boyfriend.playAnim('hey', true);
				dad.playAnim('cheer', true);
			}

		if (curBeat % 16 == 15 && SONG.song == 'Tutorial-Remix' && dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48)
			{
				boyfriend.playAnim('hey', true);
				dad.playAnim('cheer', true);
			}

		if (curSong == 'Too Clergy' && dad.curCharacter == 'sarvente')
		{
			switch (curBeat)
			{
				case 48:
					remove(dad);
					dad = new Character(630, 554, 'ruv', false);
					iconP2.animation.play('ruv');
					add(dad);
			}
		}

		if (curSong == 'Too Clergy' && boyfriend.curCharacter == 'bf')
		{
			switch (curBeat)
			{

				case 80:
					remove(boyfriend);
					boyfriend = new Boyfriend(1379, 554, 'sarvente');
					iconP1.animation.play('sarvente');
					add(boyfriend);
			}
		}

		if (curSong == 'Too Clergy' && boyfriend.curCharacter == 'sarvente')
		{
			switch (curBeat)
			{

				case 88:
					remove(boyfriend);
					boyfriend = new Boyfriend(1379, 881, 'bf');
					iconP1.animation.play('bf');
					add(boyfriend);
			}
		}

		if (curSong == 'Too Clergy' && boyfriend.curCharacter == 'bf')
		{
			switch (curBeat)
			{

				case 96:
					remove(boyfriend);
					boyfriend = new Boyfriend(1379, 554, 'sarvente');
					iconP1.animation.play('sarvente');
					add(boyfriend);
			}
		}

		if (curSong == 'Too Clergy' && boyfriend.curCharacter == 'sarvente')
		{
			switch (curBeat)
			{

				case 104:
					remove(boyfriend);
					boyfriend = new Boyfriend(1379, 881, 'bf');
					iconP1.animation.play('bf');
					add(boyfriend);
			}
		}

		if (curSong == 'Too Clergy' && dad.curCharacter == 'ruv')
		{
			switch (curBeat)
			{

				case 144:
					remove(dad);
					dad = new Character(630, 554, 'sarvente', false);
					iconP2.animation.play('sarvente');
					add(dad);
			}
		}

		if (curSong == 'Too Clergy' && dad.curCharacter == 'sarvente')
		{
			switch (curBeat)
			{

				case 176:
					remove(dad);
					dad = new Character(630, 554, 'ruv', false);
					iconP2.animation.play('ruv');
					add(dad);
			}
		}

		if (curSong == 'Too Clergy' && boyfriend.curCharacter == 'bf')
		{
			switch (curBeat)
			{
				case 208:
					remove(boyfriend);
					boyfriend = new Boyfriend(1379, 554, 'sarvente');
					iconP1.animation.play('sarvente');
					add(boyfriend);
			}
		}
		
		if (curSong == 'Too Clergy' && boyfriend.curCharacter == 'sarvente')
		{
			switch (curBeat)
			{
				case 216:
					remove(boyfriend);
					boyfriend = new Boyfriend(1379, 881, 'bf');
					iconP1.animation.play('bf');
					add(boyfriend);
			}
		}

		if (curSong == 'Too Clergy' && boyfriend.curCharacter == 'bf')
		{
			switch (curBeat)
			{
				case 224:
					remove(boyfriend);
					boyfriend = new Boyfriend(1379, 554, 'sarvente');
					iconP1.animation.play('sarvente');
					add(boyfriend);
			}
		}

		if (curSong == 'Too Clergy' && boyfriend.curCharacter == 'sarvente')
		{
			switch (curBeat)
			{
				case 232:
					remove(boyfriend);
					boyfriend = new Boyfriend(1379, 881, 'bf');
					iconP1.animation.play('bf');
					add(boyfriend);

			}
		}

		if (curSong == 'Panic Stricken' && dad.curCharacter == 'ruv')
		{
			switch (curBeat)
			{
				case 104:
					remove(dad);
					dad = new Character(630, 554, 'sarvente', false);
					iconP2.animation.play('sarvente');
					add(dad);
			}
		}

		if (curSong == 'Panic Stricken' && dad.curCharacter == 'sarvente')
		{
			switch (curBeat)
			{
				case 120:
					remove(dad);
					dad = new Character(630, 554, 'ruv', false);
					iconP2.animation.play('ruv');
					add(dad);
			}
		}

		if (curSong == 'Panic Stricken' && dad.curCharacter == 'ruv')
		{
			switch (curBeat)
			{
				case 136:
					remove(dad);
					dad = new Character(630, 554, 'sarvente', false);
					iconP2.animation.play('sarvente');
					add(dad);
			}
		}

		if (curSong == 'Panic Stricken' && dad.curCharacter == 'sarvente')
		{
			switch (curBeat)
			{
				case 152:
					remove(dad);
					dad = new Character(630, 554, 'ruv', false);
					iconP2.animation.play('ruv');
					add(dad);
			}
		}

		if (curSong == 'Panic Stricken' && dad.curCharacter == 'ruv')
		{
			switch (curBeat)
			{
				case 168:
					remove(dad);
					dad = new Character(630, 554, 'sarvente', false);
					iconP2.animation.play('sarvente');
					add(dad);
			}
		}

		if (curSong == 'Panic Stricken' && dad.curCharacter == 'sarvente')
		{
			switch (curBeat)
			{
				case 248:
					remove(dad);
					dad = new Character(630, 554, 'ruv', false);
					iconP2.animation.play('ruv');
					add(dad);
			}
		}

		if (curSong == 'Panic Stricken' && dad.curCharacter == 'ruv')
		{
			switch (curBeat)
			{
				case 264:
					remove(dad);
					dad = new Character(630, 554, 'sarvente', false);
					iconP2.animation.play('sarvente');
					add(dad);
			}
		}

		if (curSong == 'Panic Stricken' && dad.curCharacter == 'sarvente')
		{
			switch (curBeat)
			{
				case 280:
					remove(dad);
					dad = new Character(630, 554, 'ruv', false);
					iconP2.animation.play('ruv');
					add(dad);
			}
		}

		if (curSong == 'Panic Stricken' && dad.curCharacter == 'ruv')
		{
			switch (curBeat)
			{
				case 296:
					remove(dad);
					dad = new Character(630, 554, 'sarvente', false);
					iconP2.animation.play('sarvente');
					add(dad);
			}
		}

		if (curSong == 'Panic Stricken' && dad.curCharacter == 'sarvente')
		{
			switch (curBeat)
			{
				case 328:
					remove(dad);
					dad = new Character(630, 554, 'ruv', false);
					iconP2.animation.play('ruv');
					add(dad);
			}
		}

		if (curSong == 'Panic Stricken' && dad.curCharacter == 'ruv')
		{
			switch (curBeat)
			{
				case 360:
					remove(dad);
					dad = new Character(630, 554, 'sarvente', false);
					iconP2.animation.play('sarvente');
					add(dad);
			}
		}

		if (curSong == 'Panic Stricken' && dad.curCharacter == 'sarvente')
		{
			switch (curBeat)
			{
				case 376:
					remove(dad);
					dad = new Character(630, 554, 'ruv', false);
					iconP2.animation.play('ruv');
					add(dad);
			}
		}

		if (curSong == 'Panic Stricken' && dad.curCharacter == 'ruv')
		{
			switch (curBeat)
			{
				case 392:
					remove(dad);
					dad = new Character(630, 554, 'sarvente', false);
					iconP2.animation.play('sarvente');
					add(dad);
			}
		}

		if (curSong == 'Panic Stricken' && dad.curCharacter == 'sarvente')
		{
			switch (curBeat)
			{
				case 406:
					remove(dad);
					dad = new Character(630, 554, 'ruv', false);
					iconP2.animation.play('ruv');
					add(dad);
			}
		}

		switch (curStage)
		{
			case 'tank':
				if(FlxG.save.data.distractions){
					tankWatchtower.animation.play('idle', true);
					tank0.animation.play('idle', true);
					tank1.animation.play('idle', true);
					tank2.animation.play('idle', true);
					tank4.animation.play('idle', true);
					tank5.animation.play('idle', true);
					tank3.animation.play('idle', true);
				}

			case 'school':
				if(FlxG.save.data.distractions){
					bgGirls.dance();
				}

			case 'mall':
				if(FlxG.save.data.distractions){
					upperBoppers.animation.play('bop', true);
					bottomBoppers.animation.play('bop', true);
					santa.animation.play('idle', true);
				}

			case 'limo':
				if(FlxG.save.data.distractions){
					grpLimoDancers.forEach(function(dancer:BackgroundDancer)
						{
							dancer.dance();
						});
		
						if (FlxG.random.bool(10) && fastCarCanDrive)
							fastCarDrive();
				}
			case "philly":
				if(FlxG.save.data.distractions){
					if (!trainMoving)
						trainCooldown += 1;
	
					if (curBeat % 4 == 0)
					{
						phillyCityLights.forEach(function(light:FlxSprite)
						{
							light.visible = false;
						});
	
						curLight = FlxG.random.int(0, phillyCityLights.length - 1);
	
						phillyCityLights.members[curLight].visible = true;
						// phillyCityLights.members[curLight].alpha = 1;
				}

				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					if(FlxG.save.data.distractions){
						trainCooldown = FlxG.random.int(-4, 0);
						trainStart();
					}
				}
		}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			if(FlxG.save.data.distractions){
				lightningStrikeShit();
			}
		}
	}

	var curLight:Int = 0;
}
