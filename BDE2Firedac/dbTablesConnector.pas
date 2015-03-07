unit db_store_types;

interface


{$I delphi.inc}

{$ifdef BPL}
 {$undef DBX}
 {$undef ZEOSLIB}
 {$undef FireDac}
{$endif}

{$ifdef VER280}
   {$define FIREDAC}
   {$define BDE2FIREDAC}
{$endif}


uses sysutils, classes,{$ifdef FMX}FMX.Dialogs,{$else} Dialogs,{$endif}
IniFiles,IniFilesEx,
{$IFDEF FIREDAC}
  fireTables,{$ifdef NOBDE}DBTables,{$endif}
{$else}

{$IFDEF DBX}
  dbxDbTables,
{$ELSE}
{$IFDEF ZEOSLIB}
  DB,zDbTables,
{$ELSE}
  DB,DBTables,
{$ENDIF}
{$ENDIF}
{$ENDIF}
  windows;

type

{$ifndef FireDac}
{$ifndef DBX}
  {$ifndef ZEOSLIB}
    TSessionBDE = class(TSession)
      public
         procedure CloseDatabases;
    end;
  {$endif}
{$endif}
{$endif}

  {$ifdef FIREDAC}
   TUpdateSql = TFireUpdateSQL;
  {$else}
    {$ifdef ZEOSLIB}
      TUpdateSQL = TmiUpdateSQL;
    {$endif}
  {$endif}

  // conversão para tipo BASE independente do Driver em USO;
  TQueryBASE = {$ifdef FireDac} TFireQuery {$else} {$ifdef DBX}y TdbxQuery {$else} {$IFDEF ZEOSLIB}TmiQuery{$ELSE}TQuery{$ENDIF}{$endif}{$endif};
  TTableTypeBase ={$ifdef FireDac}TFireTableType {$else} {$ifdef DBX} tdbxTableType {$else}{$IFDEF ZEOSLIB} TmiTableType{$ELSE}TTableType{$ENDIF}{$endif}{$endif};
  TTableBASE = {$ifdef FireDac}{$ifdef BPL}TFireTable{$else} TFireTable{$endif} {$else} {$ifdef DBX} TdbxTable {$else}{$IFDEF ZEOSLIB}TmiTable{$ELSE}TTable{$ENDIF}{$endif}{$endif};
  TDataBaseBASE = {$ifdef FireDac} TFireDatabase {$else}  {$ifdef DBX} TdbxDatabase {$else}{$IFDEF ZEOSLIB}TmiDatabase{$ELSE}TDatabase{$ENDIF}{$endif}{$endif};
  TSessionBASE = {$ifdef FireDac} TFireSession {$else} {$ifdef DBX} TDbxSession {$else}{$IFDEF ZEOSLIB} TmiSession{$ELSE} TSession{$ENDIF}{$endif}{$endif};
  TUpdateSqlBASE = {$ifdef FireDac} TFireUpdateSql {$else} {$ifdef DBX} TdbxUpdateSql {$else}{$IFDEF ZEOSLIB} TmiUpdateSQL{$ELSE}TUpdateSQL{$ENDIF}{$endif}{$endif};
{$ifdef WINDOWS}
  TBatchMoveBASE = {$ifdef FireDac} TFireBatchMove {$else} {$ifdef DBX} TdbxBatchMove {$else}{$IFDEF ZEOSLIB} TmiBatchMove{$ELSE} TBatchMove{$ENDIF}{$endif}{$endif};
  TBatchModeBASE = {$ifdef FireDac} TFireBatchMode {$else}{$ifdef DBX} TdbxBatchMode {$else}{$IFDEF ZEOSLIB} TmiBatchMode{$ELSE} TBatchMode{$ENDIF}{$endif}{$endif};
{$endif}
  TDatabaseNotifyEventBASE = {$ifdef FireDac} TFireDatabaseNotifyEvent {$else} {$ifdef DBX} TdbxDatabaseNotifyEvent {$else}  {$IFDEF ZEOSLIB}TmiDatabaseNotifyEvent{$ELSE}TDatabaseNotifyEvent{$ENDIF}{$endif}{$endif};
  TDatabaseEventBASE = {$ifdef FireDac} TFireDatabaseEvent{$else} {$ifdef DBX} TdbxDatabaseEvent {$else}  {$IFDEF ZEOSLIB}TmiDatabaseEvent{$ELSE}TDatabaseEvent{$ENDIF}{$endif}{$endif};
  TTransIsolationBASE ={$ifdef FireDac}TFireTransIsolation{$else}{$ifdef DBX} TdbxTransIsolation {$else}  {$IFDEF ZEOSLIB} TmiTransIsolation {$ELSE} TTransIsolation{$ENDIF}{$endif}{$endif};
  TStoredProcBASE = {$ifdef FireDac} TFireStoredProc {$else} {$ifdef DBX} TdbxStoredProc {$else}{$IFDEF ZEOSLIB} TmiStoredProc{$ELSE} TStoredProc{$ENDIF}{$endif}{$endif};

  //UpWhereKeyOnlyBASE = {$ifdef DBX} UpWhereKeyOnlyDBX {$else} {$IFDEF ZEOSLIB} 0 {$else}  UpWhereKeyOnly {$endif}{$endif};
  TParamBase = {$ifdef FireDac} TFireParam {$else} TParam {$endif};
  TParamsBase = {$ifdef FireDac} TFireParams {$else} TParams {$endif};




function SessionBASE: {$ifdef FireDac} TFireSession {$else} {$ifdef DBX} TdbxSession {$else}{$IFDEF ZEOSLIB} TmiSession {$ELSE}TSessionBDE{$ENDIF}{$endif}{$endif};
function SessionsBASE: {$ifdef FireDac} TFireSessions {$else} {$ifdef DBX}TdbxSessions {$else}{$IFDEF ZEOSLIB} TmiSessions {$ELSE}TSessionList{$ENDIF}{$endif}{$endif};
procedure ProcReloadParams(proc:TStoredProcBase);

{$ifdef ZEOSLIB}
     function miConnectDataBase(AliasNameConfig, DataBaseNameVirtual: string;
              Usuario, Senha: string): TmiDatabase;
{$endif}



procedure SetConnectionIni(sFileName: string);
function getConnectionIni: string;


  {$ifdef BDE2FIREDAC}
  type
      TTable=class(TFireTable);
      TQuery=class(TFireQuery);
      TSession=class(TFireSession);
      TSessions=class(TFireSessions);
      TStoredProc=class( TStoredProcBase );
      TDatabase = class(TDatabaseBASE);
   function Session:TSession;
   function Sessions:TSessions;
  {$endif}





implementation

{$ifdef BDE2FIREDAC}
     function Session:TSession;
     begin
       result := TSession(SessionBase);
     end;
         function Sessions:TSessions;
         begin
           result := TSessions(SessionsBase);
         end;
{$endif}

{$ifdef ZEOSLIB}
     function miConnectDataBase(AliasNameConfig, DataBaseNameVirtual: string;
              Usuario, Senha: string): TmiDatabase;
     begin
         result := zDbTables.miConnectDataBase(AliasNameConfig,DataBaseNameVirtual,Usuario,Senha);
     end;
{$endif}


function SessionBASE:{$ifdef FireDac} TFireSession {$else} {$ifdef DBX} TdbxSession {$else} {$IFDEF ZEOSLIB} TmiSession {$ELSE}TSessionBDE{$ENDIF}{$endif}{$endif};
begin
  result :={$ifdef FireDac} FireSession {$else} {$ifdef DBX} dbxSession {$else} {$IFDEF ZEOSLIB} miSession {$ELSE}TSessionBDE(Session){$ENDIF}{$endif}{$endif};
end;

function SessionsBASE: {$ifdef FireDac} TFireSessions {$else}{$ifdef DBX} TdbxSessions {$else} {$IFDEF ZEOSLIB} TmiSessions {$ELSE}TSessionList{$ENDIF}{$endif}{$endif};
begin
  result := {$ifdef FireDac} FireSessions {$else} {$ifdef DBX} dbxSessions {$else} {$IFDEF ZEOSLIB} miSessions {$ELSE}Sessions{$ENDIF}{$endif}{$endif};
end;

{$ifndef FireDac}
{$ifndef DBX}
{ TSessionBDE }
{$ifndef ZEOSLIB}
procedure TSessionBDE.CloseDatabases;
var i:integer;
begin
    for i := 0 to DatabaseCount - 1 do
      if databases[i].connected then
         Databases[i].Close;
      end;
{$endif}
{$endif}
{$endif}


procedure ProcReloadParams(proc:TStoredProcBase);
begin
   {$ifdef FIREDAC}
        proc.Unprepare;
        proc.Params.Clear;
        proc.Prepare;
   {$endif}
end;


var FConnectionIni:string;

function getConnectionIni: string;
begin
  result := FConnectionIni;
end;

procedure SetConnectionIni(sFileName: string);
var
  sPath: string;
begin

  FConnectionIni := sFileName;
  if (not FileExists(FConnectionIni)) or (sametext(sFileName,extractFileName(sFileName))) then
  begin
    FConnectionIni := {$ifndef BPL}GetIniFilesDir +{$endif} ExtractFileName(sFileName);
  end;

  sPath := ExtractFilePath(sFileName);
  if sPath <> '' then
    if not DirectoryExists(sPath) then
      MkDir(sPath);

  if not FileExists(FConnectionIni) then
  begin
    ShowMessage('Falta arquivo de configuração: ' + FConnectionIni);
  end;

end;



end.
