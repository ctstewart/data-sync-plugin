<?php

/**
 * @file
 *
 * Reads data from a Google Spreadsheet that needs authentication.
 */

require '/vendor/autoload.php';

/**
 * Set here the full path to the private key .json file obtained when you
 * created the service account. Notice that this path must be readable by
 * this script.
 */
$service_account_file = '/credentials.json';

/**
 * This is the long string that identifies the spreadsheet. Pick it up from
 * the spreadsheet's URL and paste it below.
 */
$spreadsheet_id = getenv('SPREADSHEET_ID');

/**
 * This is the range that you want to extract out of the spreadsheet. It uses
 * A1 notation. For example, if you want a whole sheet of the spreadsheet, then
 * set here the sheet name.
 *
 * @see https://developers.google.com/sheets/api/guides/concepts#a1_notation
 */
$spreadsheet_range = getenv('SPREADSHEET_RANGE');

putenv('GOOGLE_APPLICATION_CREDENTIALS=' . $service_account_file);
$client = new Google_Client();
$client->useApplicationDefaultCredentials();
$client->addScope(Google_Service_Sheets::SPREADSHEETS);
$service = new Google_Service_Sheets($client);
 
$values=array_map(function($v){return str_getcsv($v, "\t");}, file('/output.txt')); 
 
$valueRange = new Google_Service_Sheets_ValueRange(array( 
    'values' => $values 
)); 
$conf = ["valueInputOption" => "RAW"]; 
$result = $service->spreadsheets_values->update($spreadsheet_id, $spreadsheet_range, $valueRange, $conf);