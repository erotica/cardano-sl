module Pos.Binary.Update.Relay
       (
       ) where

import           Universum

import           Pos.Binary.Class (Bi (..))
import           Pos.Binary.Core.Update ()
import           Pos.Binary.Infra ()
import           Pos.Communication.Types.Relay (DataMsg (..))
import           Pos.Core (HasConfiguration)
import qualified Pos.Core.Update as U
import           Pos.Crypto (hash)

----------------------------------------------------------------------------
-- Relay
----------------------------------------------------------------------------

instance HasConfiguration =>
         Bi (DataMsg (U.UpdateProposal, [U.UpdateVote])) where
    encode = encode . dmContents
    decode = do
        c@(up, votes) <- decode
        let !id = hash up
        unless (all ((id ==) . U.uvProposalId) votes) $ fail
            "decode@DataMsg@Update: vote's uvProposalId must be equal UpId"
        pure $ DataMsg c

instance HasConfiguration => Bi (DataMsg U.UpdateVote) where
    encode = encode . dmContents
    decode = DataMsg <$> decode
