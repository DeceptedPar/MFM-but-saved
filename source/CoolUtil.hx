package;

import lime.utils.Assets;

using StringTools;

class CoolUtil
{
	public static var difficultyArray:Array<String>/* = ['EASY', "NORMAL", "HARD", "ALT", "EASY-OG", "NORMAL-OG", "HARD-OG", "ALT-OG", "EASY-ALPHA", "NORMAL-ALPHA", "HARD-ALPHA", "ALT-ALPHA", "EASY-OLD", "NORMAL-OLD", "HARD-OLD", "ALT-OLD"];*/
	{
		switch (curSong.toLowerCase())
		{
			case 'tutorial':
				storyDifficultyText = ['NORMAL'];

			case 'tutorial remix':
				storyDifficultyText = [
					'NORMAL',
					'EASY-OG',
					'NORMAL-OG',
					'HARD-OG',
					'ALT-OG',
					'NORMAL-ALPHA',
					'HARD-ALPHA',
					'ALT-ALPHA'
				];

			case 'bopeebo':
				storyDifficultyText = [
					'EASY',
					'NORMAL',
					'HARD',
					//'ALT',
					'EASY-OLD',
					'NORMAL-OLD',
					'HARD-OLD'
				];

			case 'fresh':
				storyDifficultyText = [
					'EASY',
					'NORMAL',
					'HARD',
					//'ALT',
					'EASY-OLD',
					'NORMAL-OLD',
					'HARD-OLD',
				];

			case 'dad battle':
				storyDifficultyText = [
					'EASY',
					'NORMAL',
					'HARD',
					//'ALT',
					'EASY-OLD',
					'NORMAL-OLD',
					'HARD-OLD',
				];

			case 'spookeez':
				storyDifficultyText = [
					'EASY',
					'NORMAL',
					'HARD',
					//'ALT',
					'EASY-OLD',
					'NORMAL-OLD',
					'HARD-OLD',
				];

			case 'south':
				storyDifficultyText = [
					'EASY',
					'NORMAL',
					'HARD',
					//'ALT',
					'EASY-OLD',
					'NORMAL-OLD',
					'HARD-OLD',
				];

			case 'monster':
				storyDifficultyText = [
					'EASY',
					'NORMAL',
					'HARD',
					//'ALT',
					'EASY-OLD',
					'NORMAL-OLD',
					'HARD-OLD',
				];

			case 'pico':
				storyDifficultyText = [
					'EASY',
					'NORMAL',
					'HARD',
					//'ALT',
					'EASY-OLD',
					'NORMAL-OLD',
					'HARD-OLD',
				];

			case 'philly nice':
				storyDifficultyText = [
					'EASY',
					'NORMAL',
					'HARD',
					//'ALT',
					'EASY-OLD',
					'NORMAL-OLD',
					'HARD-OLD',
				];

			case 'blammed':
				storyDifficultyText = [
					'EASY',
					'NORMAL',
					'HARD',
					//'ALT',
					'EASY-OLD',
					'NORMAL-OLD',
					'HARD-OLD',
				];

			case 'satin panties':
				storyDifficultyText = [
					'EASY',
					'NORMAL',
					'HARD',
					//'ALT',
					'EASY-OLD',
					'NORMAL-OLD',
					'HARD-OLD',
				];

			case 'high':
				storyDifficultyText = [
					'EASY',
					'NORMAL',
					'HARD',
					//'ALT',
					'EASY-OLD',
					'NORMAL-OLD',
					'HARD-OLD',
				];

			case 'milf':
				storyDifficultyText = [
					'EASY',
					'NORMAL',
					'HARD',
					//'ALT',
					'EASY-OLD',
					'NORMAL-OLD',
					'HARD-OLD',
				];

			case 'cocoa':
				storyDifficultyText = [
					'EASY',
					'NORMAL',
					'HARD',
					//'ALT',
					'EASY-OLD',
					'NORMAL-OLD',
					'HARD-OLD',
				];

			case 'eggnog':
				storyDifficultyText = [
					'EASY',
					'NORMAL',
					'HARD',
					//'ALT',
					'EASY-OLD',
					'NORMAL-OLD',
					'HARD-OLD',
				];

			case 'winter horrorland':
				storyDifficultyText = [
					'EASY',
					'NORMAL',
					'HARD',
					//'ALT',
					'EASY-OLD',
					'NORMAL-OLD',
					'HARD-OLD',
				];

			case 'senpai':
				storyDifficultyText = [
					'EASY',
					'NORMAL',
					'HARD',
					//'ALT',
					'EASY-OLD',
					'NORMAL-OLD',
					'HARD-OLD',
				];

			case 'roses':
				storyDifficultyText = [
					'EASY',
					'NORMAL',
					'HARD',
					//'ALT',
					'EASY-OLD',
					'NORMAL-OLD',
					'HARD-OLD',
				];

			case 'thorns':
				storyDifficultyText = [
					'EASY',
					'NORMAL',
					'HARD',
					//'ALT',
					'EASY-OLD',
					'NORMAL-OLD',
					'HARD-OLD',
				];

			case 'parish':
				storyDifficultyText = [
					'EASY', 
					'NORMAL',
					'HARD',
					'ALT',
					'EASY-OG',
					'NORMAL-OG',
					'HARD-OG',
					'ALT-OG',
					'EASY-ALPHA',
					'NORMAL-ALPHA',
					'HARD-ALPHA',
					'ALT-ALPHA',
					'EASY-OLD',
					'NORMAL-OLD',
					'HARD-OLD',
					'ALT-OLD',
				];

			case 'worship':
				storyDifficultyText = [
					'EASY', 
					'NORMAL',
					'HARD',
					'ALT',
					'EASY-OG',
					'NORMAL-OG',
					'HARD-OG',
					'ALT-OG',
					'EASY-ALPHA',
					'NORMAL-ALPHA',
					'HARD-ALPHA',
					'ALT-ALPHA',
					'EASY-OLD',
					'NORMAL-OLD',
					'HARD-OLD',
					'ALT-OLD',
				];

			case 'zavodila':
				storyDifficultyText = [
					'EASY', 
					'NORMAL',
					'HARD',
					'ALT',
					'EASY-OG',
					'NORMAL-OG',
					'HARD-OG',
					'ALT-OG',
					'EASY-ALPHA',
					'NORMAL-ALPHA',
					'HARD-ALPHA',
					'ALT-ALPHA',
					'EASY-OLD',
					'NORMAL-OLD',
					'HARD-OLD',
					'ALT-OLD',
				];

			case 'gospel':
				storyDifficultyText = [
					'EASY', 
					'NORMAL',
					'HARD',
					'ALT',
					'EASY-OG',
					'NORMAL-OG',
					'HARD-OG',
					'ALT-OG',
					'EASY-ALPHA',
					'NORMAL-ALPHA',
					'HARD-ALPHA',
					'ALT-ALPHA',
					'EASY-OLD',
					'NORMAL-OLD',
					'HARD-OLD',
					'ALT-OLD',
				];

			case 'casanova':
				storyDifficultyText = [
					'EASY',
					'NORMAL',
					'HARD',
					'ALT',
					'EASY-OG',
					'NORMAL-OG',
					'HARD-OG',
					'ALT-OG',
					'NORMAL-OLD',
					'ALT-OLD',
				];
		});
	});

	public static function storyDifficultyTextString():String
	{
		return difficultyArray[PlayState.storyDifficulty];
	}

	public static function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String> = Assets.getText(path).trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}
	
	public static function coolStringFile(path:String):Array<String>
		{
			var daList:Array<String> = path.trim().split('\n');
	
			for (i in 0...daList.length)
			{
				daList[i] = daList[i].trim();
			}
	
			return daList;
		}

	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max)
		{
			dumbArray.push(i);
		}
		return dumbArray;
	}
}
