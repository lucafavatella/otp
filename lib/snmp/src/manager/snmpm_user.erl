%% 
%% %CopyrightBegin%
%% 
%% Copyright Ericsson AB 2004-2009. All Rights Reserved.
%% 
%% The contents of this file are subject to the Erlang Public License,
%% Version 1.1, (the "License"); you may not use this file except in
%% compliance with the License. You should have received a copy of the
%% Erlang Public License along with this software. If not, it can be
%% retrieved online at http://www.erlang.org/.
%% 
%% Software distributed under the License is distributed on an "AS IS"
%% basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
%% the License for the specific language governing rights and limitations
%% under the License.
%% 
%% %CopyrightEnd%
%% 

-module(snmpm_user).

-include("../../include/snmp_types.hrl"). %% TODO remove dots for flymake

-type target_name() :: nonempty_string().
-type oid() :: [byte()].

-callback handle_error(ReqId, Reason, UserData) -> Reply when
      ReqId    :: integer(),
      Reason   :: term(),
      UserData :: term(), %% supplied when the user registers
      Reply    :: ignore.

-callback handle_agent(Addr, Port, Type, SnmpInfo, UserData) -> Reply when
      Addr        :: term(),
      Port        :: integer(),
      Type        :: pdu | trap | inform | report,
      SnmpInfo    :: {ErrorStatus, ErrorIndex, Varbinds},
      UserId      :: term(),
      ErrorStatus :: atom(),
      ErrorIndex  :: integer(),
      Varbinds    :: [#varbind{}],
      UserData    :: term(), %% supplied when the user registers
      Reply       :: ignore | {register, UserId, AgentInfo}, %% XXX agent_info()?
      AgentInfo   :: [{AgentInfoItem :: term(), AgentInfoValue :: term()}]. %% This is the same info as in update_agent_info/4

-callback handle_pdu(TargetName, ReqId, SnmpResponse, UserData) -> Reply when
      TargetName   :: target_name(),
      ReqId        :: term(), %% returned when calling ag(...), ...
      SnmpResponse :: {ErrorStatus, ErrorIndex, Varbinds},
      ErrorStatus  :: atom(),
      ErrorIndex   :: integer(),
      Varbinds     :: [#varbind{}],
      UserData     :: term(), %% supplied when the user registers
      Reply        :: ignore.

-callback handle_trap(TargetName, SnmpTrapInfo, UserData) -> Reply when
      TargetName   :: target_name(),
      SnmpTrapInfo :: {Enteprise, Generic, Spec, Timestamp, Varbinds} |
                      {ErrorStatus, ErrorIndex, Varbinds},
      Enteprise    :: oid(),
      Generic      :: integer(),
      Spec         :: integer(),
      Timestamp    :: integer(),
      ErrorStatus  :: atom(),
      ErrorIndex   :: integer(),
      Varbinds     :: [#varbind{}],
      UserData     :: term(), %% supplied when the user registers
      Reply        :: ignore | unregister | {register, UserId, AgentInfo :: term()}. %% XXX agent_info() ???

-callback handle_inform(TargetName, SnmpInform, UserData) -> Reply when
      TargetName  :: target_name(),
      SnmpInform  :: {ErrorStatus, ErrorIndex, Varbinds},
      ErrorStatus :: atom(),
      ErrorIndex  :: integer(),
      Varbinds    :: [#varbind{}],
      UserData    :: term(), %% supplied when the user registers
      Reply       :: ignore | unregister | {register, UserId, agent_info()} | no_reply.

-callback handle_report(TargetName, SnmpReport, UserData) -> Reply when
      TargetName  :: target_name(),
      SnmpReport  :: {ErrorStatus, ErrorIndex, Varbinds},
      ErrorStatus :: integer(),
      ErrorIndex  :: integer(),
      Varbinds    :: [#varbind{}],
      UserData    :: term(), %% supplied when the user registers
      Reply       :: ignore | unregister | {register, UserId, agent_info()}.
