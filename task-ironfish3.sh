#!/bin/bash
. $HOME/.bash_profile

get_tx_hash() {
    output_exec=$1
    echo $output_exec
    tx_hash=$(echo "$output_exec" | grep "Transaction Hash:" | cut -d ' ' -f 3)
    echo -e "Transaction Hash: $tx_hash\n"
    echo -e "Wait a few minutes for transaction confirm ...\n"
    sleep 5
    echo $tx_hash
}

wait_tx_confirmed() {
    tx_hash=$1
    tx_status=$($(which ironfish) wallet:transactions | grep $tx_hash | cut -d ' ' -f 9)
    while [ "$tx_status" != "confirmed" ]
    do
        tx_status=$($(which ironfish) wallet:transactions | grep $tx_hash | cut -d ' ' -f 9)
        echo -e "$tx_hash --> $tx_status\n"    
        sleep 30	
    done
}

asset_id_IRON=d7c86706f5817aa718cd1cfad03233bcd64a7789fd9422d3b17af6823a7e6ac6
send_to=dfc2679369551e64e3950e06a88e68466e813c63b100283520045925adbe59ca
output_exec=$($(which ironfish) wallet:send --assetId=$asset_id_IRON --amount 0.1 --fee 0.0000001 --to $send_to --confirm)

tx_hash=$(get_tx_hash $output_exec)
wait_tx_confirmed $tx_hash


ironfish wallet:mint --name $IRONFISH_WALLET --metadata "meta test" --amount 10 --fee 0.0000001 --confirm

# list assets id 
ironfish wallet:balances | grep $IRONFISH_WALLET | cut -d ' ' -f 3
ironfish wallet:balances | grep $IRONFISH_WALLET | head -1 | awk '{print $3}'


#!/bin/bash
. $HOME/.bash_profile
#============================================
# Mint Asset
#===========================================
echo -e "========================================\n"
echo -e "MINT asset with name: $IRONFISH_WALLET\n"
echo -e "========================================\n"


#month=$(date +"%m")
#day=$(date +"%d")
#hour=$(date +"%H")
#meta_data="metadata $month $day $hour"
meta_data="meta data test"
echo -e "$meta_data \n"
#output_mint=$($(which ironfish) wallet:mint --name $IRONFISH_WALLET --metadata "$meta_data" --amount 10 --fee 0.0000001 --confirm)
#echo $output_mint
tx_hash_mint=$($(which ironfish) wallet:mint --name $IRONFISH_WALLET --metadata "$meta_data" --amount 10 --fee 0.0000001 --confirm | grep "Transaction Hash:" | cut -d ' ' -f 3)
echo -e "Transaction Hash: $tx_hash_mint\n"
echo -e "Wait a few minutes for transaction confirm ...\n"
sleep 30

# tracking transaction status
tx_mint_status=$($(which ironfish) wallet:transactions | grep $tx_hash_mint | awk '{print $4}')

while [ "$tx_mint_status" != "confirmed" ]
do
    tx_mint_status=$($(which ironfish) wallet:transactions | grep $tx_hash_mint | awk '{print $4}')
	echo -e "$tx_hash_mint --> $tx_mint_status\n"    
	sleep 30	
done

# ===========================================
# SEND $IRON
# ===========================================
echo -e "========================================\n"
echo -e "Send IRON\n"
echo -e "========================================\n"

. $HOME/.bash_profile
asset_id_IRON=d7c86706f5817aa718cd1cfad03233bcd64a7789fd9422d3b17af6823a7e6ac6
send_to=dfc2679369551e64e3950e06a88e68466e813c63b100283520045925adbe59ca
output_send=$($(which ironfish) wallet:send --assetId=$asset_id_IRON --amount 0.1 --fee 0.0000001 --to $send_to --confirm)
echo $output_send

tx_hash=$(echo "$output_send" | grep "Transaction Hash:" | cut -d ' ' -f 3)
echo -e "Transaction Hash: $tx_hash\n"
echo -e "Wait a few minutes for transaction confirm ...\n"
sleep 30

# tracking transaction status
tx_status=$($(which ironfish) wallet:transactions | grep $tx_hash | cut -d ' ' -f 9)

while [ "$tx_status" != "confirmed" ]
do
    tx_status=$($(which ironfish) wallet:transactions | grep $tx_hash | cut -d ' ' -f 9)
	echo -e "$tx_hash --> $tx_status\n"    
	sleep 30	
done


#======================================================================
# Burn Assets
#======================================================================
#ironfish wallet:burn --assetId 88232d14fedbe91bd3c98013e2807ca643f0bd896e566b435cc957514df2c872 --amount 0.1 --fee 0.000001 --confirm
. $HOME/.bash_profile
echo -e "========================================\n"
echo -e "Burn asset\n"
echo -e "========================================\n"
# Get balances 
balance=$($(which ironfish) wallet:balances | grep $IRONFISH_WALLET | head -1 | awk '{print $3}')
asset_id=$($(which ironfish) wallet:balances | grep $IRONFISH_WALLET | head -1 | awk '{print $2}')
echo -e "$asset_id --> $balance\n"

minimum_balance=2
if [[ $(echo "$balance < $minimum_balance" | bc -l) -eq 1 ]]; then
	echo "The balance is below the minimum threshold"
else
	echo -e "The balance of $IRONFISH_WALLET is sufficient\n"
	
	output_burn=$($(which ironfish) wallet:burn --assetId $asset_id --amount 1 --fee 0.000001 --confirm)
	tx_hash_burn=$(echo "$output_burn" | grep "Transaction Hash:" | cut -d ' ' -f 3)
	echo -e "Transaction Hash: $tx_hash_burn\n"
	echo -e "Wait a few minutes for transaction confirm ...\n"
	sleep 30
	
	echo -e "Tracking transaction status\n"
	# tracking transaction status
	tx_status_burn=$($(which ironfish) wallet:transactions | grep $tx_hash_burn | cut -d ' ' -f 9)

	while [ "$tx_status_burn" != "confirmed" ]
	do
		tx_status_burn=$($(which ironfish) wallet:transactions | grep $tx_hash_burn | cut -d ' ' -f 9)
		echo -e "$tx_status_burn --> $tx_status_burn\n"    
		sleep 30	
	done
fi


ironfish wallet:balances | head -1 | grep $IRONFISH_WALLET | head -1
kametoko   ada935d74840595f590387f73be1f34a965056d83c40f733462ae0f03df7a713 10.00000000
kametoko   bsdv935dsdf840595f590387fsdfasdf73sdffbae1f34a965056d8sdfsdf3c4f 11.00000000
$IRON      d7c86706f5817aa718cd1cfad03233bcd64a7789fd9422d3b17af6823a7e6ac6 2.40488774
