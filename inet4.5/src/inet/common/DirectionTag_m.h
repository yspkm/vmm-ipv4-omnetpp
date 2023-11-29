//
// Generated file, do not edit! Created by opp_msgtool 6.0 from inet/common/DirectionTag.msg.
//

#ifndef __INET_DIRECTIONTAG_M_H
#define __INET_DIRECTIONTAG_M_H

#if defined(__clang__)
#  pragma clang diagnostic ignored "-Wreserved-id-macro"
#endif
#include <omnetpp.h>

// opp_msgtool version check
#define MSGC_VERSION 0x0600
#if (MSGC_VERSION!=OMNETPP_VERSION)
#    error Version mismatch! Probably this file was generated by an earlier version of opp_msgtool: 'make clean' should help.
#endif

// dll export symbol
#ifndef INET_API
#  if defined(INET_EXPORT)
#    define INET_API  OPP_DLLEXPORT
#  elif defined(INET_IMPORT)
#    define INET_API  OPP_DLLIMPORT
#  else
#    define INET_API
#  endif
#endif


namespace inet {

class DirectionTag;

}  // namespace inet

#include "inet/common/INETDefs_m.h" // import inet.common.INETDefs

#include "inet/common/TagBase_m.h" // import inet.common.TagBase


namespace inet {

/**
 * Enum generated from <tt>inet/common/DirectionTag.msg:13</tt> by opp_msgtool.
 * <pre>
 * enum Direction
 * {
 *     DIRECTION_UNDEFINED = -1;
 *     DIRECTION_INBOUND = 0;
 *     DIRECTION_OUTBOUND = 1;
 * }
 * </pre>
 */
enum Direction {
    DIRECTION_UNDEFINED = -1,
    DIRECTION_INBOUND = 0,
    DIRECTION_OUTBOUND = 1
};

inline void doParsimPacking(omnetpp::cCommBuffer *b, const Direction& e) { b->pack(static_cast<int>(e)); }
inline void doParsimUnpacking(omnetpp::cCommBuffer *b, Direction& e) { int n; b->unpack(n); e = static_cast<Direction>(n); }

/**
 * Class generated from <tt>inet/common/DirectionTag.msg:32</tt> by opp_msgtool.
 * <pre>
 * //
 * // This tag specifies the intended direction of the packet as one of inbound,
 * // outbound, or undefined. The direction should be set to:
 * //  - outbound when
 * //    - a new packet is generated (e.g. in an application or in a protocol like TCP)
 * //    - a packet is sent to the lower layer
 * //    - a packet is received from the upper layer
 * //  - inbound when
 * //    - a packet is forwarded (e.g. in a protocol like IP)
 * //    - a packet is received from the lower layer
 * //    - a packet is sent to the upper layer
 * //
 * class DirectionTag extends TagBase
 * {
 *     Direction direction = DIRECTION_UNDEFINED;
 * }
 * </pre>
 */
class INET_API DirectionTag : public ::inet::TagBase
{
  protected:
    Direction direction = DIRECTION_UNDEFINED;

  private:
    void copy(const DirectionTag& other);

  protected:
    bool operator==(const DirectionTag&) = delete;

  public:
    DirectionTag();
    DirectionTag(const DirectionTag& other);
    virtual ~DirectionTag();
    DirectionTag& operator=(const DirectionTag& other);
    virtual DirectionTag *dup() const override {return new DirectionTag(*this);}
    virtual void parsimPack(omnetpp::cCommBuffer *b) const override;
    virtual void parsimUnpack(omnetpp::cCommBuffer *b) override;

    virtual Direction getDirection() const;
    virtual void setDirection(Direction direction);
};

inline void doParsimPacking(omnetpp::cCommBuffer *b, const DirectionTag& obj) {obj.parsimPack(b);}
inline void doParsimUnpacking(omnetpp::cCommBuffer *b, DirectionTag& obj) {obj.parsimUnpack(b);}


}  // namespace inet


namespace omnetpp {

template<> inline inet::DirectionTag *fromAnyPtr(any_ptr ptr) { return check_and_cast<inet::DirectionTag*>(ptr.get<cObject>()); }

}  // namespace omnetpp

#endif // ifndef __INET_DIRECTIONTAG_M_H
