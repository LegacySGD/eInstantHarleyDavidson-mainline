<?xml version="1.0" encoding="UTF-8"?><xsl:stylesheet version="1.0" exclude-result-prefixes="java" extension-element-prefixes="my-ext" xmlns:lxslt="http://xml.apache.org/xslt" xmlns:java="http://xml.apache.org/xslt/java" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:my-ext="ext1">
<xsl:import href="HTML-CCFR.xsl"/>
<xsl:output indent="no" method="xml" omit-xml-declaration="yes"/>
<xsl:template match="/">
<xsl:apply-templates select="*"/>
<xsl:apply-templates select="/output/root[position()=last()]" mode="last"/>
<br/>
</xsl:template>
<lxslt:component prefix="my-ext" functions="formatJson">
<lxslt:script lang="javascript">
					
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
						for(var i = 0; i &lt; prizeNamesList.length; ++i)
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
						r.push('&lt;table border="0" cellpadding="2" cellspacing="1" width="100%" class="gameDetailsTable" style="table-layout:fixed"&gt;');

						r.push('&lt;tr&gt;&lt;td class="tablehead" colspan="2"&gt;');
						r.push(getTranslationByName("game", translations) + " 1");
						r.push('&lt;/td&gt;&lt;/tr&gt;');

						r.push('&lt;tr class="tablebody"&gt;');
						r.push('&lt;td&gt;');
						r.push(getTranslationByName("prize", translations));
						r.push('&lt;/td&gt;');
						r.push('&lt;td&gt;');
						r.push(prizeValues[getPrizeNameIndex(prizeNamesList, gameOne[0])]);
						r.push('&lt;/td&gt;');
						r.push('&lt;/tr&gt;');

						var RPMIndex = gameOne[1] % 6;
						var yourRPM = -1;
						var rivalsRPM = -1;
						if(gameOne[1] &lt; gameOne[2])
						{
							yourRPM = RPMWinResults[RPMIndex].split(',')[0];
							rivalsRPM = RPMWinResults[RPMIndex].split(',')[1];
						}
						else
						{
							yourRPM = RPMLoseResults[RPMIndex].split(',')[0];
							rivalsRPM = RPMLoseResults[RPMIndex].split(',')[1];
						}
						
						r.push('&lt;tr class="tablebody"&gt;');
						r.push('&lt;td&gt;');
						r.push(getTranslationByName("yourRPM", translations));
						r.push('&lt;/td&gt;');
						r.push('&lt;td&gt;');
						r.push(yourRPM);
						r.push('&lt;/td&gt;');
						r.push('&lt;/tr&gt;');

						r.push('&lt;tr class="tablebody"&gt;');
						r.push('&lt;td&gt;');
						r.push(getTranslationByName("rivalsRPM", translations));
						r.push('&lt;/td&gt;');
						r.push('&lt;td&gt;');
						r.push(rivalsRPM);
						r.push('&lt;/td&gt;');
						r.push('&lt;/tr&gt;');

												
						r.push('&lt;tr class="tablebody"&gt;');						
						r.push('&lt;td&gt;');
						r.push(getTranslationByName("gameResult", translations));
						r.push('&lt;/td&gt;');
						r.push('&lt;td&gt;');
						if(yourRPM &gt; rivalsRPM)
						{
							r.push(getTranslationByName("win", translations));
						}
						else
						{
							r.push(getTranslationByName("noWin", translations));
						}
						r.push('&lt;/td&gt;');
						r.push('&lt;/tr&gt;');

						r.push('&lt;tr class="tablebody"&gt;');						
						r.push('&lt;td&gt;');
						r.push(getTranslationByName("gameWinnings", translations));
						r.push('&lt;/td&gt;');
						r.push('&lt;td&gt;');
						if(yourRPM &gt; rivalsRPM)
						{
							r.push(prizeValues[getPrizeNameIndex(prizeNamesList, gameOne[0])]);
						}
						r.push('&lt;/td&gt;');
						r.push('&lt;/tr&gt;');

						r.push('&lt;/table&gt;');
						
						// GAME TWO
						////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
						r.push('&lt;table border="0" cellpadding="2" cellspacing="1" width="100%" class="gameDetailsTable" style="table-layout:fixed"&gt;');

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

						r.push('&lt;tr&gt;&lt;td class="tablehead" colspan="3"&gt;');
						r.push(getTranslationByName("game", translations) + " 2");
						r.push('&lt;/td&gt;&lt;/tr&gt;');

						r.push('&lt;tr class="tablehead"&gt;');
						r.push('&lt;td/&gt;');
						r.push('&lt;td&gt;');
						r.push(getTranslationByName("prize", translations));
						r.push('&lt;/td&gt;');
						r.push('&lt;td&gt;');
						r.push(getTranslationByName("symbol", translations));
						r.push('&lt;/td&gt;');
						r.push('&lt;/tr&gt;');

						var symbolSet = symbolSets[symbolSetIndex];
						var orderSet = symbolOrdering[orderSetIndex];

						var winIndex = -1;
						for(var i = 0; i &lt; gameTwo.length; ++i)
						{
							var orderIndex = parseInt(orderSet[i]);
							var symbolIndex = parseInt(symbolSet[orderIndex]);
							var missSymbol = symbols[symbolIndex];
							r.push('&lt;tr class="tablebody"&gt;');
							r.push('&lt;td&gt;');
							r.push(getTranslationByName("garage", translations) + " " + (i + 1));
							r.push('&lt;/td&gt;');
							r.push('&lt;td&gt;');
							r.push(prizeValues[getPrizeNameIndex(prizeNamesList, gameTwo[i][0])]);
							registerDebugText("Game Two [" + i + "]: " + gameTwo[i]);
							registerDebugText("Game Two Prize: " + gameTwo[i][0]);
							registerDebugText("Game Two Item: " + gameTwo[i][1]);
							r.push('&lt;/td&gt;');
							r.push('&lt;td&gt;');
							if(gameTwo[i][1] == "A")
							{
								r.push(getTranslationByName(gameTwo[i][1], translations));
								winIndex = i;
							}
							else
							{
								r.push(getTranslationByName(missSymbol, translations));
							}
							r.push('&lt;/td&gt;');
							r.push('&lt;/tr&gt;');
						}

						r.push('&lt;tr class="tablebody"&gt;');
						r.push('&lt;td&gt;');
						r.push(getTranslationByName("gameResult", translations));
						r.push('&lt;/td&gt;');
						r.push('&lt;td&gt;');
						if(winIndex != -1)
						{
							r.push(getTranslationByName("win", translations));
						}
						else
						{
							r.push(getTranslationByName("noWin", translations));
						}
						r.push('&lt;/td&gt;');
						r.push('&lt;td/&gt;');
						r.push('&lt;/tr&gt;');

						r.push('&lt;tr class="tablebody"&gt;');						
						r.push('&lt;td&gt;');
						r.push(getTranslationByName("gameWinnings", translations));
						r.push('&lt;/td&gt;');
						r.push('&lt;td&gt;');
						if(winIndex != -1)
						{
							r.push(prizeValues[getPrizeNameIndex(prizeNamesList, gameTwo[winIndex][0])]);
						}
						r.push('&lt;/td&gt;');
						r.push('&lt;td/&gt;');
						r.push('&lt;/tr&gt;');

						r.push('&lt;/table&gt;');

						// GAME THREE
						////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
						r.push('&lt;table border="0" cellpadding="2" cellspacing="1" width="100%" class="gameDetailsTable" style="table-layout:fixed"&gt;');
						
						r.push('&lt;tr&gt;&lt;td class="tablehead" colspan="2"&gt;');
						r.push(getTranslationByName("game", translations) + " 3");
						r.push('&lt;/td&gt;&lt;/tr&gt;');

						var targetSym = gameThree[0];
						var wheelResult = 0;
						for(var i = 1; i &lt; gameThree.length; ++i)
						{
							var prizeName = gameThree[i][0];
							var wedge = gameThree[i][1];

							r.push('&lt;tr class="tablebody"&gt;');
							r.push('&lt;td&gt;');
							r.push(getTranslationByName("prize", translations) + " " + i);
							r.push('&lt;/td&gt;');
							r.push('&lt;td&gt;');
							r.push(prizeValues[getPrizeNameIndex(prizeNamesList, prizeName)]);
							r.push('&lt;/td&gt;');
							r.push('&lt;/tr&gt;');

							if(wedge == targetSym)
							{
								wheelResult = i;
							}
						}

						r.push('&lt;tr class="tablebody"&gt;');
						r.push('&lt;td&gt;');
						r.push(getTranslationByName("wheelResult", translations));
						r.push('&lt;/td&gt;');
						r.push('&lt;td&gt;');
						if(wheelResult != 0)
						{
							r.push(getTranslationByName("prize", translations) + " " + wheelResult);
						}
						else
						{
							r.push(getTranslationByName("blank", translations));
						}
						r.push('&lt;/td&gt;');
						r.push('&lt;/tr&gt;');

						r.push('&lt;tr class="tablebody"&gt;');
						r.push('&lt;td&gt;');
						r.push(getTranslationByName("gameResult", translations));
						r.push('&lt;/td&gt;');
						r.push('&lt;td&gt;');
						if(wheelResult != 0)
						{
							r.push(getTranslationByName("win", translations));
						}
						else
						{
							r.push(getTranslationByName("noWin", translations));
						}
						r.push('&lt;/td&gt;');
						r.push('&lt;/tr&gt;');

						r.push('&lt;tr class="tablebody"&gt;');						
						r.push('&lt;td&gt;');
						r.push(getTranslationByName("gameWinnings", translations));
						r.push('&lt;/td&gt;');
						r.push('&lt;td&gt;');
						if(wheelResult != 0)
						{
							r.push(prizeValues[getPrizeNameIndex(prizeNamesList, gameThree[wheelResult][0])]);
						}
						r.push('&lt;/td&gt;');
						r.push('&lt;/tr&gt;');
						
						r.push('&lt;/table&gt;');

						// GAME FOUR
						////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
						r.push('&lt;table border="0" cellpadding="2" cellspacing="1" width="100%" class="gameDetailsTable" style="table-layout:fixed"&gt;');

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

						
						r.push('&lt;tr&gt;&lt;td class="tablehead" colspan="4"&gt;');
						r.push(getTranslationByName("game", translations) + " 4");
						r.push('&lt;/td&gt;&lt;/tr&gt;');

						r.push('&lt;tr class="tablehead"&gt;');
						r.push('&lt;td/&gt;');
						r.push('&lt;td&gt;');
						r.push(getTranslationByName("prize", translations));
						r.push('&lt;/td&gt;');
						r.push('&lt;td&gt;');
						r.push(getTranslationByName("symbol", translations));
						r.push('&lt;/td&gt;');
						r.push('&lt;td&gt;');
						r.push(getTranslationByName("match", translations));
						r.push('&lt;/td&gt;');
						r.push('&lt;/tr&gt;');

						var matchThree = "X";
						for(var i = 0; i &lt; gameFour.length; ++i)
						{
							var prizeName = gameFour[i];
							var prizeCount = countPrizeCollections(prizeName, gameFour);

							r.push('&lt;tr class="tablebody"&gt;');
							r.push('&lt;td&gt;');
							r.push(getTranslationByName("selection", translations) + " " + i);
							r.push('&lt;/td&gt;');
							r.push('&lt;td&gt;');
							r.push(prizeValues[getPrizeNameIndex(prizeNamesList, prizeName)]);
							r.push('&lt;/td&gt;');
							r.push('&lt;td&gt;');
							r.push(getTranslationByName(uniqueColors[uniqueItems.indexOf(prizeName)], translations));
							r.push('&lt;/td&gt;');
							r.push('&lt;td&gt;');
							if(prizeCount == 3)
							{
								r.push("X");
								matchThree = prizeName;
							}
							r.push('&lt;/td&gt;');
							r.push('&lt;/tr&gt;');
						}

						
						r.push('&lt;tr class="tablebody"&gt;');
						r.push('&lt;td&gt;');
						r.push(getTranslationByName("gameResult", translations));
						r.push('&lt;/td&gt;');
						r.push('&lt;td&gt;');
						if(matchThree != "X")
						{
							r.push(getTranslationByName("win", translations));
						}
						else
						{
							r.push(getTranslationByName("noWin", translations));
						}
						r.push('&lt;/td&gt;');
						r.push('&lt;td/&gt;');
						r.push('&lt;td/&gt;');
						r.push('&lt;/tr&gt;');

						r.push('&lt;tr class="tablebody"&gt;');						
						r.push('&lt;td&gt;');
						r.push(getTranslationByName("gameWinnings", translations));
						r.push('&lt;/td&gt;');
						r.push('&lt;td&gt;');
						if(matchThree != "X")
						{
							r.push(prizeValues[getPrizeNameIndex(prizeNamesList, matchThree)]);
						}
						r.push('&lt;/td&gt;');
						r.push('&lt;td/&gt;');
						r.push('&lt;td/&gt;');
						r.push('&lt;/tr&gt;');
						
						r.push('&lt;/table&gt;');
						
						
						////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
						// !DEBUG OUTPUT TABLE
						
						if(debugFlag)
						{
							// DEBUG TABLE
							//////////////////////////////////////
							r.push('&lt;table border="0" cellpadding="2" cellspacing="1" width="100%" class="gameDetailsTable" style="table-layout:fixed"&gt;');
							for(var idx = 0; idx &lt; debugFeed.length; ++idx)
							{
								r.push('&lt;tr&gt;');
								r.push('&lt;td class="tablebody"&gt;');
								r.push(debugFeed[idx]);
								r.push('&lt;/td&gt;');
								r.push('&lt;/tr&gt;');
							}
							r.push('&lt;/table&gt;');
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
						for(var i = 0; i &lt; prizeNames.length; ++i)
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
						for(var i = 0; i &lt; inputArr.length; i++) {
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
						for(var char = 0; char &lt; scenario.length; ++char)
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
						for(var i = 0; i &lt; winningNums.length; ++i)
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
						while(index &lt; translationNodeSet.item(0).getChildNodes().getLength())
						{
							var childNode = translationNodeSet.item(0).getChildNodes().item(index);
							
							if(childNode.name == "phrase" &amp;&amp; childNode.getAttribute("key") == keyName)
							{
								registerDebugText("Child Node: " + childNode.name);
								return childNode.getAttribute("value");
							}
							
							index += 1;
						}
					}					
					
				</lxslt:script>
</lxslt:component>
<xsl:template match="root" mode="last">
<table border="0" cellpadding="1" cellspacing="1" width="100%" class="gameDetailsTable">
<tr>
<td valign="top" class="subheader">
<xsl:value-of select="//translation/phrase[@key='totalWager']/@value"/>
<xsl:value-of select="': '"/>
<xsl:call-template name="Utils.ApplyConversionByLocale">
<xsl:with-param name="multi" select="/output/denom/percredit"/>
<xsl:with-param name="value" select="//ResultData/WagerOutcome[@name='Game.Total']/@amount"/>
<xsl:with-param name="code" select="/output/denom/currencycode"/>
<xsl:with-param name="locale" select="//translation/@language"/>
</xsl:call-template>
</td>
</tr>
<tr>
<td valign="top" class="subheader">
<xsl:value-of select="//translation/phrase[@key='totalWins']/@value"/>
<xsl:value-of select="': '"/>
<xsl:call-template name="Utils.ApplyConversionByLocale">
<xsl:with-param name="multi" select="/output/denom/percredit"/>
<xsl:with-param name="value" select="//ResultData/PrizeOutcome[@name='Game.Total']/@totalPay"/>
<xsl:with-param name="code" select="/output/denom/currencycode"/>
<xsl:with-param name="locale" select="//translation/@language"/>
</xsl:call-template>
</td>
</tr>
</table>
</xsl:template>
<xsl:template match="//Outcome">
<xsl:if test="OutcomeDetail/Stage = 'Scenario'">
<xsl:call-template name="Scenario.Detail"/>
</xsl:if>
</xsl:template>
<xsl:template name="Scenario.Detail">
<table border="0" cellpadding="0" cellspacing="0" width="100%" class="gameDetailsTable">
<tr>
<td class="tablebold" background="">
<xsl:value-of select="//translation/phrase[@key='transactionId']/@value"/>
<xsl:value-of select="': '"/>
<xsl:value-of select="OutcomeDetail/RngTxnId"/>
</td>
</tr>
</table>
<xsl:variable name="odeResponseJson" select="string(//ResultData/JSONOutcome[@name='ODEResponse']/text())"/>
<xsl:variable name="translations" select="lxslt:nodeset(//translation)"/>
<xsl:variable name="wageredPricePoint" select="string(//ResultData/WagerOutcome[@name='Game.Total']/@amount)"/>
<xsl:variable name="prizeTable" select="lxslt:nodeset(//lottery)"/>
<xsl:variable name="convertedPrizeValues">
<xsl:apply-templates select="//lottery/prizetable/prize" mode="PrizeValue"/>
</xsl:variable>
<xsl:variable name="prizeNames">
<xsl:apply-templates select="//lottery/prizetable/description" mode="PrizeDescriptions"/>
</xsl:variable>
<xsl:value-of select="my-ext:formatJson($odeResponseJson, $translations, $prizeTable, string($convertedPrizeValues), string($prizeNames))" disable-output-escaping="yes"/>
</xsl:template>
<xsl:template match="prize" mode="PrizeValue">
<xsl:text>|</xsl:text>
<xsl:call-template name="Utils.ApplyConversionByLocale">
<xsl:with-param name="multi" select="/output/denom/percredit"/>
<xsl:with-param name="value" select="text()"/>
<xsl:with-param name="code" select="/output/denom/currencycode"/>
<xsl:with-param name="locale" select="//translation/@language"/>
</xsl:call-template>
</xsl:template>
<xsl:template match="description" mode="PrizeDescriptions">
<xsl:text>,</xsl:text>
<xsl:value-of select="text()"/>
</xsl:template>
<xsl:template match="text()"/>
</xsl:stylesheet>
