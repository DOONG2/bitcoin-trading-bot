summoney = 0
gainmoney = 0
buymoney = 0
selltargetlevel = 0
avgmoney = 0
Awesomenumber=0.2 ; change
coin = 0
commission = 0
buythisprice = 0
firstprice = 0
;buylimittarget
FBTM := firstprice - (firstprice * 0.93) ; FirstBuyTargetMoney
SBTM := firstprice - (firstprice * 0.99)
TBTM := firstprice - (firstprice * 0.98)
LBTM := firstprice - (firstprice * 0.96)

;selltargetpercentage
STPALL=0;
FSTP := 1.03 ;firstselltargetpercentage    ;change
SSTP := 1.06 ;secondselltargetpercentage	;change
TSTP := 1.12 ; thirdselltargetpercentage	;change
LSTP := 1.18 ;lastselltargetpercentage	;change
;howmuch
trademoney :=10000	;change
TMY := trademoney
;limitcount
FLC := 3 ;firstlimitcnt	;change
SLC := 11 ;secondlimitcnt	;change
TLC := 20 ;thirdlimitcnt	;change
LLC := 27 ;lastlimitcnt	;change

Gui, Add, Text, x32 y29 w100 h30 , 총자산
Gui, Add, Text, x32 y79 w100 h30 , 현재코인
Gui, Add, Text, x32 y129 w100 h30 , 구매 횟수
Gui, Add, Text, x32 y179 w100 h30 , 평 단가
Gui, Add, Text, x162 y29 w100 h30 vmymoney, %mymoney%
Gui, Add, Text, x162 y79 w100 h30 vcoin, %coin%
Gui, Add, Text, x162 y129 w100 h30 vbuycnt, %buycnt%
Gui, Add, Text, x162 y179 w100 h30 vavgmoney, %avgmoney%
Gui, Add, Button, x22 y269 w190 h70 , 시작(F2)
Gui, Add, Button, x252 y269 w190 h70 , 일시정지(F3)
Gui, Add, Text, x32 y219 w410 h30 , 영차~ 영차~ 힘을내세요! 화이팅!
Gui, Add, Button, x282 y19 w170 h70 , 설정(F7)
Gui, Add, Text, x282 y109 w80 h30 , 예상 판매가
Gui, Add, Text, x372 y109 w80 h30 vsellchecker, %sellchecker%
Gui, Add, Text, x282 y159 w80 h40 , 이득 총액
Gui, Add, Text, x372 y159 w80 h40 vgainmoney, %gainmoney%
Gui, Add, GroupBox, x12 y9 w260 h210 , 현재 상황
Gui, Add, GroupBox, x262 y89 w200 h120 , 예상
Gui, Show, x815 y240 h379 w479, BitJuSeYo_Ver_3.0

buycnt = 0
F2::
Button시작(F2):
Loop,{
	
	FBTM := firstprice - (firstprice * 0.93) ; FirstBuyTargetMoney
	SBTM := firstprice - (firstprice * 0.99)
	TBTM := firstprice - (firstprice * 0.98)
	LBTM := firstprice - (firstprice * 0.96)
	gosub, inputdata
	
	if(sellprice>=350000 and buyprice>=350000){
		if(buycnt=0){
			selltargetlevel =0 
			gosub,buy
			firstprice := sellprice
			FBTM := firstprice - (firstprice * 0.93) ; FirstBuyTargetMoney
			SBTM := firstprice - (firstprice * 0.99)
			TBTM := firstprice - (firstprice * 0.98)
			LBTM := firstprice - (firstprice * 0.96)
			
		} else {
			gosub,selltargetleveldecision
			sellchecker := avgmoney*STPALL
			guicontrol,,sellchecker,%sellchecker%
			if(sellchecker <= buyprice){
				gosub,sell
			}
		 if(mymoney>10000  ){ 
			if(buycnt<FLC){
				selltargetlevel =1
				gosub % ((buythisprice - FBTM) >= sellprice) ? ("buy"): ("stay") 	;change
			}
			else {
				if(buycnt<SLC){
						selltargetlevel =2
					gosub % ((buythisprice - SBTM) >= sellprice) ? ("buy") : ("stay") 	;change
				}
				if(buycnt>=SLC and buycnt<TLC){
						selltargetlevel =3
						gosub % ((buythisprice - TBTM) >= sellprice) ? ("buy") :("stay") 	;change
					}
					if(buycnt>=TLC and buycnt<LLC ){
						selltargetlevel =4
						gosub % ((buythisprice - LBTM) >= sellprice) ? ("buy") :("stay") 	;change
					}				
				
			
		}
	}
 }
}
WinActivate, BitJuSeYo_Ver_3.0
sleep, 2000
}
inputdata: 
{
		Sleep, 100
		WinActivate, 코빗
		Sleep, 100
		Mouseclick, left, 1910,45
		sleep, 300
	Imagesearch, ax, ay, 0, 0, 1900, 60, *50 black.png
	if (ErrorLevel = 0) 
		{
			Mouseclick, left, 1686,300    ;창 찍기(black)
			Sleep, 100
			Mouseclick, left, 1277,98     ;가끔뜨는 오류창 닫기 클릭(black)
			sleep, 100
			Mouseclick, left, 765,380,2   ; 매도 입력창(black)
			Sleep, 100
			Send, 1
			send, {bs}
			Sleep, 100
			Mouseclick, left, 1165,380,2   ;매수 입력창(black)
			Sleep, 100
			Send, 1
			send, {bs}
			Sleep, 100
			Mouseclick, left, 1910,45       ;스크롤바 맨위클릭
			Sleep, 100
			Mouseclick, left, 1686,300     ;창 찍기(black)
			Sleep, 100
			Send, ^a
			sleep, 100
			Send, ^c
			sleep, 100
			Mouseclick, left, 1686,344          ;창 찍기(black)
			str = %Clipboard%
			righttime = %a_now%
			result := strsplit(str, "`n")
			
			mymoney := result[12] ; 나의돈 (black)
			prices := result[50]  ; 매도 매수 첫번째칸 (black)
		}
	if (ErrorLevel = 1)
		{
			Mouseclick, left, 1686,300    ;창 찍기
			Sleep, 100
			Mouseclick, left, 1277,28      ;가끔뜨는 오류창 닫기 클릭
			sleep, 100
			Mouseclick, left, 765,310,2      ;매수 입력창
			Sleep, 100
			Send, 1
			send, {bs}
			Sleep, 100
			Mouseclick, left, 1165,310,2       ;매도 입력창
			Sleep, 100
			Send, 1
			send, {bs}
			Sleep, 100
			Mouseclick, left, 1910,45        ;맨위 스크롤바
			Sleep, 100
			Mouseclick, left, 1686,300        ;창찍기
			Sleep, 100
			Send, ^a
			sleep, 100
			Send, ^c
			sleep, 100
			Mouseclick, left, 1686,344         ;창찍기
			str = %Clipboard%
			righttime = %a_now%
			result := strsplit(str, "`n")
			
			mymoney := result[11] ;나의돈
			prices := result[49]   ;매수 매도 첫번째칸
		}
			

			realprices := strsplit(prices, "	")
			sellprice :=realprices[4]
			buyprice :=realprices[3]
			sellprice := RegExReplace(sellprice,"[^0-9]")
			buyprice :=  RegExReplace(buyprice,"[^0-9]")
			mymoney :=  RegExReplace(mymoney,"[^0-9]")
		
			FileAppend, %righttime%>money>%mymoney%`n,input1.txt
			FileAppend, %righttime%>sellprice>%sellprice%`n,input1.txt
			FileAppend, %righttime%>buyprice>%buyprice%`n,input1.txt
			guicontrol,,mymoney,%mymoney% 
			return
		
	}
selltargetleveldecision:
{
if(selltargetlevel = 1 or selltargetlevel = 0){
		STPALL := FSTP
		}else if(selltargetlevel = 2){
		STPALL := SSTP
		}else if(selltargetlevel = 3){
		STPALL := TSTP
		}else if(selltargetlevel = 4){
		STPALL := LSTP
		}else 	STPALL := LSTP 
	return
	}
sell: 
{
		
		Mouseclick, left, 1686,300
		Sleep, 100
		Mouseclick, left, 1910,45
		Sleep, 300
		
		Imagesearch, ax, ay, 0, 0, 1900, 60, *50 black.png
		if (ErrorLevel = 0)
			{
				;기본 매도
				sleep, 100
				Mouseclick, left, 1277,98
				sleep, 100
				Mouseclick, left, 500,370   ;비트코인캐시 메뉴클릭(black)
				sleep, 10000
				Mouseclick, left, 940,310   ;시장가 클릭(black)
				Sleep, 500
				Mouseclick, left, 1686,300
				Sleep, 100
				MouseMove, 1254, 420
				Sleep, 300
				MouseClick, Left, 1254, 420
				Sleep, 300
				MouseMove, 1254, 474
				Sleep, 500
				Mouseclick, left, 1254, 544
				Sleep, 1500
				;911,237
				;Mousemove 911,237
				MouseMove 1004,260
				Sleep, 300	
				;MouseClick, left,911,237
				Mouseclick, left, 1004,260
				sleep, 5000
				
				
						;매도 확인, 인풋데이터
						Mouseclick, left, 1686,300
						Sleep, 100
						Mouseclick, left, 500,370  ;비트코인캐시 메뉴클릭(black)
						sleep, 10000
						Mouseclick, left, 940,310   ;시장가 클릭(black)
						Sleep, 500
						Mouseclick, left, 1686,300
						Sleep, 100
						Mouseclick, left, 765,380,2  ;매수 입력창 클릭(black)
						Sleep, 100
						Send, 1
						send, {bs}
						Sleep, 100
						Mouseclick, left, 1165,380,2  ;매도 입력창 클릭(black)
						Sleep, 100
						Send, 1
						send, {bs}
						Sleep, 100
						Mouseclick, left, 1910,45
						Sleep, 100
						Mouseclick, left, 1686,300
						Sleep, 100
						Send, ^a
						sleep, 100
						Send, ^c
						sleep, 100
						Mouseclick, left, 1686,344
						str = %Clipboard%
						righttime = %a_now%
						result := strsplit(str, "`n")
						
						mymoney := result[12] ; 나의돈 
						prices := result[50]
						resultcheck := result[88]    ;가장 최근거래(black)
						resultch := strsplit(resultcheck, "	") 
						resultcheck1 :=  resultch[1]   ;SELL뽑아내기
						
						
						while (resultcheck1 = "Buy")    ;매도하고 SELL이아니라 BUY라면 다시 매도시도
						{
							;매도시도
							Sleep, 100
							Mouseclick, left, 500,370
							sleep, 10000
							Mouseclick, left, 940,310
							Sleep, 500
							Mouseclick, left, 1686,300
							Sleep, 100
							MouseMove, 1254, 420
							Sleep, 300
							MouseClick, Left, 1254, 420
							Sleep, 300
							MouseMove, 1254, 474
							Sleep, 500
							Mouseclick, left, 1254, 544
							Sleep, 1500
							;911,237
							;Mousemove 911,237
							MouseMove 1004,260
							Sleep, 300	
							;MouseClick, left,911,237
							Mouseclick, left, 1004,260
							sleep, 5000
							
							
							;매도확인 및 새로고침
							Mouseclick, left, 1686,300
							
							sleep, 100
							Mouseclick, left, 1277,98    
							Sleep, 100
							Mouseclick, left, 765,380,2  ;매수 입력창 클릭(black)
							Sleep, 100
							Send, 1
							send, {bs}
							Sleep, 100
							Mouseclick, left, 1165,380,2  ;매도 입력창클릭(black)
							Sleep, 100
							Send, 1
							send, {bs}
							Sleep, 100
							Mouseclick, left, 1910,45
							Sleep, 100
							Mouseclick, left, 1686,300
							Sleep, 100
							Send, ^a
							sleep, 100
							Send, ^c
							sleep, 100
							Mouseclick, left, 1686,344
							str = %Clipboard%
							righttime = %a_now%
							result := strsplit(str, "`n")
							mymoney := result[12] ; 나의돈 
							prices := result[50]
							resultcheck := result[88]    ;가장 최근거래 타입위치(black)
							resultch := strsplit(resultcheck, "	") 
							resultcheck1 :=  resultch[1]   ;SELL뽑아내기
							
							
						}
						
						
			}
		if (ErrorLevel = 1)
			{
				
				;기본매도
				Sleep, 100
				Mouseclick, left, 500,300
				sleep, 10000
				
				Mouseclick, left, 940,240
				Sleep, 500
				Mouseclick, left, 1686,300
				Sleep, 100
				Mouseclick, left, 1277,28
				Sleep, 100
				MouseMove, 1254, 350
				Sleep, 300
				MouseClick, Left, 1254, 350
				Sleep, 300
				MouseMove, 1254, 474
				Sleep, 500
				Mouseclick, left, 1254, 474
				Sleep, 1500
				;911,237
				;Mousemove 911,237
				MouseMove 1004,260
				Sleep, 300	
				;MouseClick, left,911,237
				Mouseclick, left, 1004,260
				sleep, 5000
				
				
				;매도 확인및 인풋데이터
				Mouseclick, left, 1686,300
						Sleep, 100
						Mouseclick, left, 500,300
						sleep, 10000
						Mouseclick, left, 940,240
						Sleep, 500
						Mouseclick, left, 1686,300
						Sleep, 100
						Mouseclick, left, 1277,28
						Sleep, 100
						Mouseclick, left, 765,310,2
						Sleep, 100
						Send, 1
						send, {bs}
						Sleep, 100
						Mouseclick, left, 1165,310,2
						Sleep, 100
						Send, 1
						send, {bs}
						Sleep, 100
						Mouseclick, left, 1910,45
						Sleep, 100
						Mouseclick, left, 1277,28
						Sleep, 100
						Mouseclick, left, 1686,300
						Sleep, 100
						Send, ^a
						sleep, 100
						Send, ^c
						sleep, 100
						Mouseclick, left, 1686,344
						str = %Clipboard%
						righttime = %a_now%
						result := strsplit(str, "`n")
						
						mymoney := result[11] ; 나의돈 
						prices := result[49]
						resultcheck := result[87]
						resultch := strsplit(resultcheck, "	") 
						resultcheck1 :=  resultch[1]
						
						
						while (resultcheck1 = "Buy")
						{
							Sleep, 100
							Mouseclick, left, 500,300
							sleep, 10000
							Mouseclick, left, 940,240
							Sleep, 500
							Mouseclick, left, 1686,300
							Sleep, 100
							MouseMove, 1254, 350
							Sleep, 300
							MouseClick, Left, 1254, 350
							Sleep, 300
							MouseMove, 1254, 474
							Sleep, 500
							Mouseclick, left, 1254, 474
							Sleep, 1500
							;911,237
							;Mousemove 911,237
							MouseMove 1004,260
							Sleep, 300	
							;MouseClick, left,911,237
							Mouseclick, left, 1004,260
							sleep, 5000
							
							
							Mouseclick, left, 1686,300
							Sleep, 100
							Mouseclick, left, 765,310,2
							Sleep, 100
							Send, 1
							send, {bs}
							Sleep, 100
							Mouseclick, left, 1165,310,2
							Sleep, 100
							Send, 1
							send, {bs}
							Sleep, 100
							Mouseclick, left, 1910,45
							Sleep, 100
							Mouseclick, left, 1277,28
							Sleep, 100
							Mouseclick, left, 1686,300
							Sleep, 100
							Send, ^a
							sleep, 100
							Send, ^c
							sleep, 100
							Mouseclick, left, 1686,344
							str = %Clipboard%
							righttime = %a_now%
							result := strsplit(str, "`n")
							mymoney := result[11] ; 나의돈 
							prices := result[49]
							resultcheck := result[87]
							resultch := strsplit(resultcheck, "	") 
							resultcheck1 :=  resultch[1]
								
							
						}
			}
		

		A :=(buyprice-avgmoney)*coin*0.998
		gainmoney := gainmoney + A -commission
		gappercentage := (sellprice-avgmoney)/avgmoney
		avgmoney := 0
		summoney := 0
		buycnt := 0
		coin :=0
		commission :=0
		firstprice = 0
		guicontrol,,avgmoney,%avgmoney% 
		guicontrol,,buycnt,%buycent% 
		guicontrol,,gainmoney,%gainmoney%
		guicontrol,,coin,%coin%
		
		FileAppend, %righttime%>sellpattern>%gappercentage%>%sellprice%>%gainmoney%`n,output1.txt
		
		return
	}

	
buy: 
{
				buycnt++
				
				TMY:= TMY*((Awesomenumber*buycnt)+0.80) ; change
				
				Mouseclick, left, 1686,300
				Sleep, 100
				Mouseclick, left, 1910,45
				Sleep, 300
				Imagesearch, ax, ay, 0, 0, 1900, 60, *50 black.png
				if (ErrorLevel = 0)
					{
						Mouseclick, left, 1277,98    ;가끔뜨는 오류창 닫기클릭(black)
						sleep, 100
						Mouseclick, left, 500,370   ;비트코인캐시 메뉴 클릭(black)
						sleep, 10000
						Mouseclick, left, 940,310    ;시장가 클릭 (black)
						Sleep, 500
						Mouseclick, left, 1686,300
						Sleep, 100
						MouseMove 765,381
						Sleep, 100
						Mouseclick, left, 765,381, 2   ;매수 입력창 클릭(black)
						Sleep, 100
						send, {bs}
						Sleep, 100
						
						TMY := Floor(TMY)
						Send, %TMY%
						Sleep, 100
						
						Mouseclick, left, 864,541
						Sleep, 1500
						MouseMove 1004,261
						Sleep, 100
						Mouseclick, left,1004,260
						Sleep, 5000
						
						
						;매수 확인
						Mouseclick, left, 1686,300
						Sleep, 100
						Mouseclick, left, 1277,98
						sleep, 100
						Mouseclick, left, 765,380,2   ;매수 입력창 클릭(black)
						Sleep, 100
						Send, 1
						send, {bs}
						Sleep, 100
						Mouseclick, left, 1165,380,2  ;매도 입력창 클릭(black)
						Sleep, 100
						Send, 1
						send, {bs}
						Sleep, 100
						Mouseclick, left, 1910,45
						Sleep, 100
						Mouseclick, left, 1277,98
						sleep, 100
						Mouseclick, left, 1686,300
						Sleep, 100
						Send, ^a
						sleep, 100
						Send, ^c
						sleep, 100
						Mouseclick, left, 1686,344
						str = %Clipboard%
						righttime = %a_now%
						result := strsplit(str, "`n")
						
						mymoney := result[12] ; 나의돈 (black)
						prices := result[50]   ;매수가 매도가 첫번째위치 (black)
						resultcheck := result[89]   ; 가장 최근거래 상세위치(black)
						resultch := strsplit(resultcheck, "	") 
						resultcheck1 :=  resultch[5]  ; 구매액위치(black)
						resultcheck1 := RegExReplace(resultcheck1,"[^0-9]") 
						
						while( resultcheck1 = (TMY-2000))  ;구매액이 현재의 count 전값의 구매액이라면 다시 매수시도
						{
							
							Sleep, 100
							Mouseclick, left, 500,370
							sleep, 10000
							Mouseclick, left, 940,310
							Sleep, 500
							Mouseclick, left, 1686,300
							Sleep, 100
							Mouseclick, left, 1277,98
							sleep, 100
							MouseMove 765,381
							Sleep, 100
							Mouseclick, left, 765,381, 2
							Sleep, 100
							send, {bs}
							Sleep, 100
							
							TMY := Floor(TMY)
							Send, %TMY%
							Sleep, 100
							
							Mouseclick, left, 864,541
							Sleep, 1500
							MouseMove 1004,261
							Sleep, 100
							Mouseclick, left,1004,260
							Sleep, 5000
							
							;매수 확인
							Mouseclick, left, 1686,300
							Sleep, 100
							Mouseclick, left, 500,370
							sleep, 10000
							Mouseclick, left, 940,310
							Sleep, 500
							Mouseclick, left, 1686,300
							Sleep, 100
							Mouseclick, left, 1277,98
							sleep, 100
							Mouseclick, left, 765,380,2
							Sleep, 100
							Send, 1
							send, {bs}
							Sleep, 100
							Mouseclick, left, 1165,380,2
							Sleep, 100
							Send, 1
							send, {bs}
							Sleep, 100
							Mouseclick, left, 1910,45
							Sleep, 100
							Mouseclick, left, 1277,98
							sleep, 100
							Mouseclick, left, 1686,300
							Sleep, 100
							Send, ^a
							sleep, 100
							Send, ^c
							sleep, 100
							Mouseclick, left, 1686,344
							str = %Clipboard%
							righttime = %a_now%
							result := strsplit(str, "`n")
							
							mymoney := result[12] ; 나의돈 
							prices := result[50]
							resultcheck := result[89]
							resultch := strsplit(resultcheck, "	") 
							resultcheck1 :=  resultch[5]
							resultcheck1 := RegExReplace(resultcheck1,"[^0-9]")
						}
						
					}
				if (ErrorLevel = 1)
					{
						Mouseclick, left, 1277,28
						Sleep, 100
						Mouseclick, left, 500,300
						sleep, 10000
						Mouseclick, left, 940,240
						Sleep, 500
						Mouseclick, left, 1686,300
						Sleep, 100
						MouseMove 765,311
						Sleep, 100
						Mouseclick, left, 765,311, 2
						Sleep, 100
						send, {bs}
						Sleep, 100
						
						TMY := Floor(TMY)
						Send, %TMY%
						Sleep, 100
						
						Mouseclick, left, 864,471
						Sleep, 1500
						MouseMove 1004,261
						Sleep, 100
						Mouseclick, left,1004,260
						Sleep, 5000
						
						;확인
						Mouseclick, left, 1686,300
						Sleep, 100
						Mouseclick, left, 1277,28
						sleep, 100
						Mouseclick, left, 765,310,2
						Sleep, 100
						Send, 1
						send, {bs}
						Sleep, 100
						Mouseclick, left, 1165,310,2
						Sleep, 100
						Send, 1
						send, {bs}
						Sleep, 100
						Mouseclick, left, 1910,45
						Sleep, 100
						Mouseclick, left, 1277,28
						sleep, 100
						Mouseclick, left, 1686,300
						Sleep, 100
						Send, ^a
						sleep, 100
						Send, ^c
						sleep, 100
						Mouseclick, left, 1686,344
						str = %Clipboard%
						righttime = %a_now%
						result := strsplit(str, "`n")
						
						mymoney := result[11] ; 나의돈 
						prices := result[49]
						resultcheck := result[88]
						resultch := strsplit(resultcheck, "	") 
						resultcheck1 :=  resultch[5]
						resultcheck1 := RegExReplace(resultcheck1,"[^0-9]")
						
						while( resultcheck1 = (TMY-2000))
						{
							
							Sleep, 100
							Mouseclick, left, 500,300
							sleep, 10000
							Mouseclick, left, 940,240
							Sleep, 500
							Mouseclick, left, 1686,300
							Sleep, 100
							Mouseclick, left, 1277,28
							sleep, 100
							MouseMove 765,311
							Sleep, 100
							Mouseclick, left, 765,311, 2
							Sleep, 100
							send, {bs}
							Sleep, 100
							
							TMY := Floor(TMY)
							Send, %TMY%
							Sleep, 100
							
							Mouseclick, left, 864,471
							Sleep, 1500
							MouseMove 1004,261
							Sleep, 100
							Mouseclick, left,1004,260
							Sleep, 5000
							
							Mouseclick, left, 1686,300
							Sleep, 100
							Mouseclick, left, 765,310,2
							Sleep, 100
							Send, 1
							send, {bs}
							Sleep, 100
							Mouseclick, left, 1165,310,2
							Sleep, 100
							Send, 1
							send, {bs}
							Sleep, 100
							Mouseclick, left, 1910,45
							Sleep, 100
							Mouseclick, left, 1277,28
							sleep, 100
							Mouseclick, left, 1686,300
							Sleep, 100
							Send, ^a
							sleep, 100
							Send, ^c
							sleep, 100
							Mouseclick, left, 1686,344
							str = %Clipboard%
							righttime = %a_now%
							result := strsplit(str, "`n")
							
							mymoney := result[11] ; 나의돈 
							prices := result[49]
							resultcheck := result[88]
							resultch := strsplit(resultcheck, "	") 
							resultcheck1 :=  resultch[5]
							resultcheck1 := RegExReplace(resultcheck1,"[^0-9]")
							
							
						}
					}
				
				buythisprice := sellprice
				buymoney:= TMY
				commission := 0.008*buymoney + commission
				coin := (coin + (buymoney/sellprice))
				summoney := summoney+buymoney
				avgmoney := summoney/coin
				TMY:= trademoney
				
				guicontrol,,avgmoney,%avgmoney% 
				guicontrol,,buycnt,%buycnt%
				guicontrol,,coin,%coin%
				guicontrol,,gainmoney,%gainmoney% 
				FileAppend, %righttime%>buypattern%TMY%>%gappercentage%>%sellprice%>%buymoney%>%summoney%>%avgmoney%>%buycnt%>%gainmoney%>%coin%`n,output1.txt
				Sleep, 3000
				return
				} 
stay:
{
	FileAppend, %righttime%>staypattern>sum%summoney%>avg%avgmoney%>buycount%buycnt%>gainmoney%gainmoney%>%coin%`n,output1.txt
	
	return
}
F3::
Button일시정지(F3):
pause
return
GuiClose:
ExitApp
return

F4::
MsgBox, avgmoney: %avgmoney% buycnt: %buycnt% coin: %coin% summoney: %summoney% buythisprice: %buythisprice% firstprice: %firstprice% FBTM: %FBTM% SBTM: %SBTM% TBTM: %TBTM% LBTM: %LBTM%
return

F7::
Button설정(F7):
inputbox, avgmoney,평단가, 평단가 입력
inputbox, buycnt, 구매횟수, 구매횟수 
inputbox, coin, 코인, 코인
inputbox, summoney, 총구매액, 총구매액
inputbox, buythisprice, buythisprice, buythisprice
inputbox, firstprice, firstprice, firstprice
guicontrol,,avgmoney,%avgmoney% 
guicontrol,,buycnt,%buycnt% 
guicontrol,,coin,%coin%
return
