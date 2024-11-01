<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:x="anything">
	<xsl:namespace-alias stylesheet-prefix="x" result-prefix="xsl" />
	<xsl:output encoding="UTF-8" indent="yes" method="xml" />
	<xsl:include href="../utils.xsl" />
	<xsl:template match="/Paytable">
		<x:stylesheet version="1.0" xmlns:java="http://xml.apache.org/xslt/java" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
			exclude-result-prefixes="java" xmlns:lxslt="http://xml.apache.org/xslt" xmlns:my-ext="ext1" extension-element-prefixes="my-ext">
			<x:import href="HTML-CCFR.xsl" />
			<x:output indent="no" method="xml" omit-xml-declaration="yes" />
			<!-- TEMPLATE Match: -->
			<x:template match="/">
				<x:apply-templates select="*" />
				<x:apply-templates select="/output/root[position()=last()]" mode="last" />
				<br />
			</x:template>
			<!--The component and its script are in the lxslt namespace and define the implementation of the extension. -->
			<lxslt:component prefix="my-ext" functions="formatJson">
				<lxslt:script lang="javascript">
					<![CDATA[
					var debugFeed = [];
					var debugFlag = false;					
					
					// Format instant win JSON results.
					// @param jsonContext String JSON results to parse and display.
					// @param
					function formatJson(jsonContext, translations, prizeTable, convertedPrizeValues, prizeNames)
					{
						var scenario = getScenario(jsonContext);
						var gameOne = scenario.split('|')[0].split(',');
						var gameTwo = scenario.split('|')[1].split(',');
						var gameThree = scenario.split('|')[2].split(',');
						var gameFour = scenario.split('|')[3].split(',');
						var prizeNamesList = (prizeNames.substring(1)).split(',');
						var prizeValues = (convertedPrizeValues.substring(1)).split('|');

						var RPMWinResults = ["4750,3250","6500,3500","4750,4000","6500,4000","7000,4750","7000,6500"];
						var RPMLoseResults = ["3000,3250","3250,3500","3000,4000","3500,4750","3250,4750","4000,6500"];


						// Sample Data: J,9767,9771|JK,FC,DF,AH|I,CO,AE,HJ,EB,DL,JI,FH|G,F,I,A,G,F,B,B
						
						// Filter Prize Names
						for(var i = 0; i < prizeNamesList.length; ++i)
						{
							prizeNamesList[i] = prizeNamesList[i][prizeNamesList[i].length - 1];
						}					
						
						registerDebugText("Scenario: " + scenario);
						registerDebugText("Prize Names: " + prizeNamesList);
						registerDebugText("Prize Values: " + prizeValues);
						registerDebugText("Game 1: " + gameOne);
						registerDebugText("Game 2: " + gameTwo);
						registerDebugText("Game 3: " + gameThree);
						registerDebugText("Game 4: " + gameFour);
						
						// Output winning numbers table.
						var r = [];
						// GAME ONE
						////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
						r.push('<table border="0" cellpadding="2" cellspacing="1" width="100%" class="gameDetailsTable" style="table-layout:fixed">');

						r.push('<tr><td class="tablehead" colspan="2">');
						r.push(getTranslationByName("game", translations) + " 1");
						r.push('</td></tr>');

						r.push('<tr class="tablebody">');
						r.push('<td>');
						r.push(getTranslationByName("prize", translations));
						r.push('</td>');
						r.push('<td>');
						r.push(prizeValues[getPrizeNameIndex(prizeNamesList, gameOne[0])]);
						r.push('</td>');
						r.push('</tr>');

						var RPMIndex = gameOne[1] % 6;
						var yourRPM = -1;
						var rivalsRPM = -1;
						if(gameOne[1] < gameOne[2])
						{
							yourRPM = RPMWinResults[RPMIndex].split(',')[0];
							rivalsRPM = RPMWinResults[RPMIndex].split(',')[1];
						}
						else
						{
							yourRPM = RPMLoseResults[RPMIndex].split(',')[0];
							rivalsRPM = RPMLoseResults[RPMIndex].split(',')[1];
						}
						
						r.push('<tr class="tablebody">');
						r.push('<td>');
						r.push(getTranslationByName("yourRPM", translations));
						r.push('</td>');
						r.push('<td>');
						r.push(yourRPM);
						r.push('</td>');
						r.push('</tr>');

						r.push('<tr class="tablebody">');
						r.push('<td>');
						r.push(getTranslationByName("rivalsRPM", translations));
						r.push('</td>');
						r.push('<td>');
						r.push(rivalsRPM);
						r.push('</td>');
						r.push('</tr>');

												
						r.push('<tr class="tablebody">');						
						r.push('<td>');
						r.push(getTranslationByName("gameResult", translations));
						r.push('</td>');
						r.push('<td>');
						if(yourRPM > rivalsRPM)
						{
							r.push(getTranslationByName("win", translations));
						}
						else
						{
							r.push(getTranslationByName("noWin", translations));
						}
						r.push('</td>');
						r.push('</tr>');

						r.push('<tr class="tablebody">');						
						r.push('<td>');
						r.push(getTranslationByName("gameWinnings", translations));
						r.push('</td>');
						r.push('<td>');
						if(yourRPM > rivalsRPM)
						{
							r.push(prizeValues[getPrizeNameIndex(prizeNamesList, gameOne[0])]);
						}
						r.push('</td>');
						r.push('</tr>');

						r.push('</table>');
						
						// GAME TWO
						////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
						r.push('<table border="0" cellpadding="2" cellspacing="1" width="100%" class="gameDetailsTable" style="table-layout:fixed">');

						var symbolSets = ["0123","0124","0125","0134","0135","0145","0234","0235","0245","0345","1234","1235","1245","1345","2345"];
						var symbolOrdering = ["0123","0132","0213","0231","0312","0321","1023","1032","1203","1230","1302","1320","2013","2031","2103","2130","2301","2310","3012","3021","3102","3120","3201","3210"];
						var symbols = ["wheelbarrow", "tires", "melons", "jetSki", "boxes", "bike"];

						var gameTwoIndex = (((gameTwo[0].charCodeAt(0) - 65) * 15) + (gameTwo[0].charCodeAt(1) - 65)) + 1; // Value should be between 1-150
						var symbolSetIndex = ((gameTwoIndex - 1) % 15); // Value should be between 0-14
						var orderSetIndex = ((gameTwoIndex - 1) % 24); // Value should be between 0-24
						registerDebugText("Game 2 Scenario Index: " + gameTwoIndex);
						registerDebugText("Game 2 Symbol Index: " + symbolSetIndex + ", Order: " + symbolSets[symbolSetIndex]);
						registerDebugText("Game 2 Order Index: " + orderSetIndex + ", Order: " + symbolOrdering[orderSetIndex]);
						registerDebugText("Game 2 Symbols: " + symbols[parseInt(symbolSets[symbolSetIndex][0])] + ", " + symbols[parseInt(symbolSets[symbolSetIndex][1])] + ", " + symbols[parseInt(symbolSets[symbolSetIndex][2])] + ", " + symbols[parseInt(symbolSets[symbolSetIndex][3])]);
						registerDebugText("Game 2 Symbols in Order: " + symbols[parseInt(symbolSets[symbolSetIndex][parseInt(symbolOrdering[orderSetIndex][0])])] + ", " + symbols[parseInt(symbolSets[symbolSetIndex][parseInt(symbolOrdering[orderSetIndex][1])])] + ", " + symbols[parseInt(symbolSets[symbolSetIndex][parseInt(symbolOrdering[orderSetIndex][2])])] + ", " + symbols[parseInt(symbolSets[symbolSetIndex][parseInt(symbolOrdering[orderSetIndex][3])])]);

						r.push('<tr><td class="tablehead" colspan="3">');
						r.push(getTranslationByName("game", translations) + " 2");
						r.push('</td></tr>');

						r.push('<tr class="tablehead">');
						r.push('<td/>');
						r.push('<td>');
						r.push(getTranslationByName("prize", translations));
						r.push('</td>');
						r.push('<td>');
						r.push(getTranslationByName("symbol", translations));
						r.push('</td>');
						r.push('</tr>');

						var symbolSet = symbolSets[symbolSetIndex];
						var orderSet = symbolOrdering[orderSetIndex];

						var winIndex = -1;
						for(var i = 0; i < gameTwo.length; ++i)
						{
							var orderIndex = parseInt(orderSet[i]);
							var symbolIndex = parseInt(symbolSet[orderIndex]);
							var missSymbol = symbols[symbolIndex];
							r.push('<tr class="tablebody">');
							r.push('<td>');
							r.push(getTranslationByName("garage", translations) + " " + (i + 1));
							r.push('</td>');
							r.push('<td>');
							r.push(prizeValues[getPrizeNameIndex(prizeNamesList, gameTwo[i][0])]);
							registerDebugText("Game Two [" + i + "]: " + gameTwo[i]);
							registerDebugText("Game Two Prize: " + gameTwo[i][0]);
							registerDebugText("Game Two Item: " + gameTwo[i][1]);
							r.push('</td>');
							r.push('<td>');
							if(gameTwo[i][1] == "A")
							{
								r.push(getTranslationByName(gameTwo[i][1], translations));
								winIndex = i;
							}
							else
							{
								r.push(getTranslationByName(missSymbol, translations));
							}
							r.push('</td>');
							r.push('</tr>');
						}

						r.push('<tr class="tablebody">');
						r.push('<td>');
						r.push(getTranslationByName("gameResult", translations));
						r.push('</td>');
						r.push('<td>');
						if(winIndex != -1)
						{
							r.push(getTranslationByName("win", translations));
						}
						else
						{
							r.push(getTranslationByName("noWin", translations));
						}
						r.push('</td>');
						r.push('<td/>');
						r.push('</tr>');

						r.push('<tr class="tablebody">');						
						r.push('<td>');
						r.push(getTranslationByName("gameWinnings", translations));
						r.push('</td>');
						r.push('<td>');
						if(winIndex != -1)
						{
							r.push(prizeValues[getPrizeNameIndex(prizeNamesList, gameTwo[winIndex][0])]);
						}
						r.push('</td>');
						r.push('<td/>');
						r.push('</tr>');

						r.push('</table>');

						// GAME THREE
						////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
						r.push('<table border="0" cellpadding="2" cellspacing="1" width="100%" class="gameDetailsTable" style="table-layout:fixed">');
						
						r.push('<tr><td class="tablehead" colspan="2">');
						r.push(getTranslationByName("game", translations) + " 3");
						r.push('</td></tr>');

						var targetSym = gameThree[0];
						var wheelResult = 0;
						for(var i = 1; i < gameThree.length; ++i)
						{
							var prizeName = gameThree[i][0];
							var wedge = gameThree[i][1];

							r.push('<tr class="tablebody">');
							r.push('<td>');
							r.push(getTranslationByName("prize", translations) + " " + i);
							r.push('</td>');
							r.push('<td>');
							r.push(prizeValues[getPrizeNameIndex(prizeNamesList, prizeName)]);
							r.push('</td>');
							r.push('</tr>');

							if(wedge == targetSym)
							{
								wheelResult = i;
							}
						}

						r.push('<tr class="tablebody">');
						r.push('<td>');
						r.push(getTranslationByName("wheelResult", translations));
						r.push('</td>');
						r.push('<td>');
						if(wheelResult != 0)
						{
							r.push(getTranslationByName("prize", translations) + " " + wheelResult);
						}
						else
						{
							r.push(getTranslationByName("blank", translations));
						}
						r.push('</td>');
						r.push('</tr>');

						r.push('<tr class="tablebody">');
						r.push('<td>');
						r.push(getTranslationByName("gameResult", translations));
						r.push('</td>');
						r.push('<td>');
						if(wheelResult != 0)
						{
							r.push(getTranslationByName("win", translations));
						}
						else
						{
							r.push(getTranslationByName("noWin", translations));
						}
						r.push('</td>');
						r.push('</tr>');

						r.push('<tr class="tablebody">');						
						r.push('<td>');
						r.push(getTranslationByName("gameWinnings", translations));
						r.push('</td>');
						r.push('<td>');
						if(wheelResult != 0)
						{
							r.push(prizeValues[getPrizeNameIndex(prizeNamesList, gameThree[wheelResult][0])]);
						}
						r.push('</td>');
						r.push('</tr>');
						
						r.push('</table>');

						// GAME FOUR
						////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
						r.push('<table border="0" cellpadding="2" cellspacing="1" width="100%" class="gameDetailsTable" style="table-layout:fixed">');

						var colorList = ["black", "red", "yellow", "blue", "turquoise", "purple", "white"];
						var lastReveal = gameFour[gameFour.length - 1];
						var colorIndex = lastReveal.charCodeAt(0) % 7;

						registerDebugText("Game 4 Last Reveal: " + lastReveal);
						registerDebugText("Game 4 Color Index: " + colorIndex);
						registerDebugText("Game 4 Start Color: " + colorList[colorIndex]);
						
						var uniqueItems = uniqueArray(gameFour).sort();
						registerDebugText("Game 4 Unique Items: " + uniqueItems);


						var uniqueColors = colorList.slice(colorIndex, colorList.length).concat(colorList.slice(0, colorIndex));
						registerDebugText("Game 4 Unique Colors: " + uniqueColors);

						
						r.push('<tr><td class="tablehead" colspan="4">');
						r.push(getTranslationByName("game", translations) + " 4");
						r.push('</td></tr>');

						r.push('<tr class="tablehead">');
						r.push('<td/>');
						r.push('<td>');
						r.push(getTranslationByName("prize", translations));
						r.push('</td>');
						r.push('<td>');
						r.push(getTranslationByName("symbol", translations));
						r.push('</td>');
						r.push('<td>');
						r.push(getTranslationByName("match", translations));
						r.push('</td>');
						r.push('</tr>');

						var matchThree = "X";
						for(var i = 0; i < gameFour.length; ++i)
						{
							var prizeName = gameFour[i];
							var prizeCount = countPrizeCollections(prizeName, gameFour);

							r.push('<tr class="tablebody">');
							r.push('<td>');
							r.push(getTranslationByName("selection", translations) + " " + i);
							r.push('</td>');
							r.push('<td>');
							r.push(prizeValues[getPrizeNameIndex(prizeNamesList, prizeName)]);
							r.push('</td>');
							r.push('<td>');
							r.push(getTranslationByName(uniqueColors[uniqueItems.indexOf(prizeName)], translations));
							r.push('</td>');
							r.push('<td>');
							if(prizeCount == 3)
							{
								r.push("X");
								matchThree = prizeName;
							}
							r.push('</td>');
							r.push('</tr>');
						}

						
						r.push('<tr class="tablebody">');
						r.push('<td>');
						r.push(getTranslationByName("gameResult", translations));
						r.push('</td>');
						r.push('<td>');
						if(matchThree != "X")
						{
							r.push(getTranslationByName("win", translations));
						}
						else
						{
							r.push(getTranslationByName("noWin", translations));
						}
						r.push('</td>');
						r.push('<td/>');
						r.push('<td/>');
						r.push('</tr>');

						r.push('<tr class="tablebody">');						
						r.push('<td>');
						r.push(getTranslationByName("gameWinnings", translations));
						r.push('</td>');
						r.push('<td>');
						if(matchThree != "X")
						{
							r.push(prizeValues[getPrizeNameIndex(prizeNamesList, matchThree)]);
						}
						r.push('</td>');
						r.push('<td/>');
						r.push('<td/>');
						r.push('</tr>');
						
						r.push('</table>');
						
						
						////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
						// !DEBUG OUTPUT TABLE
						
						if(debugFlag)
						{
							// DEBUG TABLE
							//////////////////////////////////////
							r.push('<table border="0" cellpadding="2" cellspacing="1" width="100%" class="gameDetailsTable" style="table-layout:fixed">');
							for(var idx = 0; idx < debugFeed.length; ++idx)
							{
								r.push('<tr>');
								r.push('<td class="tablebody">');
								r.push(debugFeed[idx]);
								r.push('</td>');
								r.push('</tr>');
							}
							r.push('</table>');
						}

						return r.join('');
					}
					
					// Input: Json document string containing 'scenario' at root level.
					// Output: Scenario value.
					function getScenario(jsonContext)
					{
						// Parse json and retrieve scenario string.
						var jsObj = JSON.parse(jsonContext);
						var scenario = jsObj.scenario;

						// Trim null from scenario string.
						scenario = scenario.replace(/\0/g, '');

						return scenario;
					}

					// Input: "A,B,C,D,..." and "A"
					// Output: index number
					function getPrizeNameIndex(prizeNames, currPrize)
					{			
						for(var i = 0; i < prizeNames.length; ++i)
						{
							if(prizeNames[i] == currPrize)
							{
								return i;
							}
						}
					}
					
					function filterCollectables(scenario)
					{
						var simpleCollections = scenario.split("|")[1];
						
						return simpleCollections;			
					}

					function uniqueArray(inputArr)
					{
						var finalArr = [];
						for(var i = 0; i < inputArr.length; i++) {
							if(finalArr.indexOf(inputArr[i]) == -1) {
								finalArr.push(inputArr[i]);
							}
						}
						return finalArr;
					}
					
					function countPrizeCollections(prizeName, scenario)
					{
						registerDebugText("Checking for prize in scenario: " + prizeName);
						var count = 0;
						for(var char = 0; char < scenario.length; ++char)
						{
							if(prizeName == scenario[char])
							{
								count++;
							}
						}
						
						return count;
					}

					// Input: List of winning numbers and the number to check
					// Output: true is number is contained within winning numbers or false if not
					function checkMatch(winningNums, boardNum)
					{
						for(var i = 0; i < winningNums.length; ++i)
						{
							if(winningNums[i] == boardNum)
							{
								return true;
							}
						}
						
						return false;
					}
	
					
					////////////////////////////////////////////////////////////////////////////////////////
					function registerDebugText(debugText)
					{
						debugFeed.push(debugText);
					}
					
					/////////////////////////////////////////////////////////////////////////////////////////
					function getTranslationByName(keyName, translationNodeSet)
					{
						var index = 1;
						while(index < translationNodeSet.item(0).getChildNodes().getLength())
						{
							var childNode = translationNodeSet.item(0).getChildNodes().item(index);
							
							if(childNode.name == "phrase" && childNode.getAttribute("key") == keyName)
							{
								registerDebugText("Child Node: " + childNode.name);
								return childNode.getAttribute("value");
							}
							
							index += 1;
						}
					}					
					]]>
				</lxslt:script>
			</lxslt:component>
			<x:template match="root" mode="last">
				<table border="0" cellpadding="1" cellspacing="1" width="100%" class="gameDetailsTable">
					<tr>
						<td valign="top" class="subheader">
							<x:value-of select="//translation/phrase[@key='totalWager']/@value" />
							<x:value-of select="': '" />
							<x:call-template name="Utils.ApplyConversionByLocale">
								<x:with-param name="multi" select="/output/denom/percredit" />
								<x:with-param name="value" select="//ResultData/WagerOutcome[@name='Game.Total']/@amount" />
								<x:with-param name="code" select="/output/denom/currencycode" />
								<x:with-param name="locale" select="//translation/@language" />
							</x:call-template>
						</td>
					</tr>
					<tr>
						<td valign="top" class="subheader">
							<x:value-of select="//translation/phrase[@key='totalWins']/@value" />
							<x:value-of select="': '" />
							<x:call-template name="Utils.ApplyConversionByLocale">
								<x:with-param name="multi" select="/output/denom/percredit" />
								<x:with-param name="value" select="//ResultData/PrizeOutcome[@name='Game.Total']/@totalPay" />
								<x:with-param name="code" select="/output/denom/currencycode" />
								<x:with-param name="locale" select="//translation/@language" />
							</x:call-template>
						</td>
					</tr>
				</table>
			</x:template>
			<!-- TEMPLATE Match: digested/game -->
			<x:template match="//Outcome">
				<x:if test="OutcomeDetail/Stage = 'Scenario'">
					<x:call-template name="Scenario.Detail" />
				</x:if>
			</x:template>
			<!-- TEMPLATE Name: Scenario.Detail (base game) -->
			<x:template name="Scenario.Detail">
				<table border="0" cellpadding="0" cellspacing="0" width="100%" class="gameDetailsTable">
					<tr>
						<td class="tablebold" background="">
							<x:value-of select="//translation/phrase[@key='transactionId']/@value" />
							<x:value-of select="': '" />
							<x:value-of select="OutcomeDetail/RngTxnId" />
						</td>
					</tr>
				</table>
				<x:variable name="odeResponseJson" select="string(//ResultData/JSONOutcome[@name='ODEResponse']/text())" />
				<x:variable name="translations" select="lxslt:nodeset(//translation)" />
				<x:variable name="wageredPricePoint" select="string(//ResultData/WagerOutcome[@name='Game.Total']/@amount)" />
				<x:variable name="prizeTable" select="lxslt:nodeset(//lottery)" />
				<x:variable name="convertedPrizeValues">
					<x:apply-templates select="//lottery/prizetable/prize" mode="PrizeValue" />
				</x:variable>
				<x:variable name="prizeNames">
					<x:apply-templates select="//lottery/prizetable/description" mode="PrizeDescriptions" />
				</x:variable>
				<x:value-of select="my-ext:formatJson($odeResponseJson, $translations, $prizeTable, string($convertedPrizeValues), string($prizeNames))"
					disable-output-escaping="yes" />
			</x:template>
			<x:template match="prize" mode="PrizeValue">
				<x:text>|</x:text>
				<x:call-template name="Utils.ApplyConversionByLocale">
					<x:with-param name="multi" select="/output/denom/percredit" />
					<x:with-param name="value" select="text()" />
					<x:with-param name="code" select="/output/denom/currencycode" />
					<x:with-param name="locale" select="//translation/@language" />
				</x:call-template>
			</x:template>
			<x:template match="description" mode="PrizeDescriptions">
				<x:text>,</x:text>
				<x:value-of select="text()" />
			</x:template>
			<x:template match="text()" />
		</x:stylesheet>
	</xsl:template>
	<xsl:template name="TemplatesForResultXSL">
		<x:template match="@aClickCount">
			<clickcount>
				<x:value-of select="." />
			</clickcount>
		</x:template>
		<x:template match="*|@*|text()">
			<x:apply-templates />
		</x:template>
	</xsl:template>
</xsl:stylesheet>